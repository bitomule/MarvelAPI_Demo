//
//  ComicCoversDataSource.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Result

protocol ComicCoversDataSource{
  func getComics(characters:[String],limit:Int?,offset:Int?)->SignalProducer<[Comic],NoError>
}

extension InMemoryDataSource:ComicCoversDataSource{
  
  func getComics(characters:[String],limit:Int?,offset:Int?)->SignalProducer<[Comic],NoError>{
    return SignalProducer({ observer, _ in
      observer.send(value: inMemoryComics)
    })
  }
  
}
