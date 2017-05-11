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
}

protocol ComicCoversInput{
  func loadMore()
  var filterByCharacters:([String])->() {get}
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
  
  //Inputs
  
  func loadMore(){
    offset = itemsCount.value
    reloadDataObserver.send(value: ())
  }
  
  var filterByCharacters:([String])->(){
    return {[weak self] charactersIds in
      self?.selectedCharacters = charactersIds
      self?.comics.value = []
      self?.reloadDataObserver.send(value: ())
    }
  }
  
  
  let dataSource:ComicCoversDataSource
  let comics:MutableProperty<[Comic]> = MutableProperty([])
  let (reloadData, reloadDataObserver) = Signal<(), NoError>.pipe()
  
  let limit:Int
  var offset = 0
  var selectedCharacters:[String] = []
  var noMoreDataAvailable = false
  
  init(limit:Int = 10,dataSource:ComicCoversDataSource = InMemoryDataSource()){
    self.dataSource = dataSource
    self.limit = limit
    
    comics <~ reloadData.filter({[weak self] _ -> Bool in
      guard let strongSelf = self else {return false}
      return !strongSelf.noMoreDataAvailable
    }).flatMap(.merge) {[weak self] _ -> SignalProducer<[Comic], NoError> in
      guard let strongSelf = self else {return SignalProducer.empty}
      return dataSource.getComics(characters: strongSelf.selectedCharacters, limit: strongSelf.limit, offset: strongSelf.offset)
        .on(value: {[weak self] comics in
          guard let strongSelf = self else {return}
          if comics.count < strongSelf.limit{
            strongSelf.noMoreDataAvailable = true
          }
        })
        .reduce(strongSelf.comics.value, { oldComics, newComics -> [Comic] in
        return oldComics + newComics
      })
    }
    
    itemsCount <~ comics.map{$0.count}
    
    reloadDataObserver.send(value: ())
    
  }
}
