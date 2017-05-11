//
//  ComicDetailDataSource.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Result

protocol ComicDetailDataSource{
  func getComic(id:Int)->SignalProducer<Comic,NoError>
}

extension InMemoryDataSource:ComicDetailDataSource{
  
  func getComic(id:Int)->SignalProducer<Comic,NoError>{
    return SignalProducer({ observer, _ in
      if let comic = inMemoryComics.first(where: {$0.id == id}){
        observer.send(value: comic)
      }
    })
  }
}
