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
  func getComics(character:Int?,limit:Int?,offset:Int?)->SignalProducer<[Comic],DataSourceError>
}
