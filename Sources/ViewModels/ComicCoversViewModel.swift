//
//  ComicCoversViewModel.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Result

protocol ComicCoversOutput{
  var itemsCount:MutableProperty<Int> {get}
  func itemAt(index:Int)->Comic
  var itemsAdded:Signal<Int,NoError> {get}
  var itemsReloaded:Signal<(),NoError> {get}
  var error:Signal<DataSourceError,NoError> {get}
}

protocol ComicCoversInput{
  func loadMore()
  var filterByCharacter:(Int)->() {get}
}

protocol ComicCoversViewModelType{
  var outputs:ComicCoversOutput {get}
  var inputs:ComicCoversInput {get}
}

final class ComicCoversViewModel:ComicCoversViewModelType,ComicCoversInput,ComicCoversOutput{
  
  
  var inputs: ComicCoversInput { return self }
  var outputs: ComicCoversOutput { return self }
  
  // Outputs
  let itemsCount:MutableProperty<Int> = MutableProperty(0)
  
  func itemAt(index:Int)->Comic{
    return comics.value[index]
  }
  
  let itemsAdded:Signal<Int, NoError>
  let itemsReloaded:Signal<(),NoError>
  
  //Inputs
  
  func loadMore(){
    offset = itemsCount.value
    reloadDataObserver.send(value: ())
  }
  
  var filterByCharacter:(Int)->(){
    return {[weak self] characterId in
      self?.selectedCharacter = characterId
      self?.comics.value = []
      self?.reloadDataObserver.send(value: ())
    }
  }
  
  
  let dataSource:ComicCoversDataSource
  let comics:MutableProperty<[Comic]> = MutableProperty([])
  let (reloadData, reloadDataObserver) = Signal<(), NoError>.pipe()
  let (error, errorObserver) = Signal<DataSourceError, NoError>.pipe()
  
  let limit:Int
  var offset = 0
  var selectedCharacter:Int? = nil
  var noMoreDataAvailable = false
  var loading = false
  
  init(limit:Int = 10,dataSource:ComicCoversDataSource = MarvelAPIDataSource()){
    self.dataSource = dataSource
    self.limit = limit
    
    itemsCount <~ comics.map{$0.count}
    
    itemsAdded = comics
      .signal
      .combinePrevious([])
      .filter({ oldItems, newItems -> Bool in
        return newItems.count > oldItems.count
      })
      .map { oldItems, newItems -> Int in
        return newItems.count - oldItems.count
    }
    
    itemsReloaded = comics
      .signal
      .combinePrevious([])
      .filter({ oldItems, newItems -> Bool in
        return oldItems.count == newItems.count || oldItems.count > newItems.count
      })
      .map{_ in ()}
    
    comics <~ SignalProducer<(), NoError>(reloadData)
      .filter({[weak self] _ -> Bool in
        guard let strongSelf = self else {return false}
        return !strongSelf.noMoreDataAvailable && !strongSelf.loading
      })
      .flatMap(.merge) {[weak self] _ -> SignalProducer<[Comic], DataSourceError> in
        guard let strongSelf = self else {return SignalProducer.empty}
        strongSelf.loading = true
        return dataSource
          .getComics(character: strongSelf.selectedCharacter, limit: strongSelf.limit, offset: strongSelf.offset)
          .on(value: {[weak self] comics in
            guard let strongSelf = self else {return}
            if comics.count < strongSelf.limit{
              strongSelf.noMoreDataAvailable = true
            }
          })
          .map{$0 + strongSelf.comics.value}
      }.on(event: {[weak self] _ in
        self?.loading = false
      }).redirectErrorsToObserver(errorObserver, replacementValue: nil)
    
    reloadDataObserver.send(value: ())
    
  }
}
