//
//  InMemoryDataSource.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Result

final class InMemoryDataSource{
  
}


extension InMemoryDataSource:ComicCoversDataSource{
  
  func getComics(character:Int?,limit:Int?,offset:Int?)->SignalProducer<[Comic],DataSourceError>{
    return SignalProducer({ observer, _ in
      observer.send(value: inMemoryComics)
    })
  }
}

extension InMemoryDataSource:ComicDetailDataSource{
  
  func getComic(id:Int)->SignalProducer<Comic,DataSourceError>{
    return SignalProducer({ observer, _ in
      if let comic = inMemoryComics.first(where: {$0.id == id}){
        observer.send(value: comic)
      }
    })
  }
}

let inMemoryComics = [
  Comic(
    id: 0,
    title: "Test 1",
    issueNumber: 1,
    description: fakeText,
    pageCount: 17,
    thumbnail: "https://static.gamespot.com/uploads/original/1562/15626911/2991050-4996630-04-variant.jpg",
    cover:"https://static.gamespot.com/uploads/original/1562/15626911/2991050-4996630-04-variant.jpg"
  ),
  Comic(
    id: 1,
    title: "Test 2",
    issueNumber: 1,
    description: fakeText,
    pageCount: 72,
    thumbnail: "https://static.comicvine.com/uploads/original/11111/111113010/2973595-surfer4.jpg",
    cover:"https://static.comicvine.com/uploads/original/11111/111113010/2973595-surfer4.jpg"
  ),
  Comic(
    id: 2,
    title: "Test 3",
    issueNumber: 1,
    description: fakeText,
    pageCount: 27,
    thumbnail: "https://s-media-cache-ak0.pinimg.com/originals/57/eb/2b/57eb2b7ae61914ed41cab8d352341982.jpg",
    cover:"https://s-media-cache-ak0.pinimg.com/originals/57/eb/2b/57eb2b7ae61914ed41cab8d352341982.jpg"
  ),
  Comic(
    id: 3,
    title: "Test 4",
    issueNumber: 1,
    description: fakeText,
    pageCount: 17,
    thumbnail: "https://comicsastonish.files.wordpress.com/2012/02/tec880.jpg",
    cover:"https://comicsastonish.files.wordpress.com/2012/02/tec880.jpg"
  ),
  Comic(
    id: 4,
    title: "Test 5",
    issueNumber: 1,
    description: fakeText,
    pageCount: 75,
    thumbnail: "https://static.comicvine.com/uploads/original/6/67663/3507925-15.jpg",
    cover:"https://static.comicvine.com/uploads/original/6/67663/3507925-15.jpg"
  ),
  Comic(
    id: 5,
    title: "Test 6",
    issueNumber: 1,
    description: fakeText,
    pageCount: 14,
    thumbnail: "https://s-media-cache-ak0.pinimg.com/originals/57/eb/2b/57eb2b7ae61914ed41cab8d352341982.jpg",
    cover:"https://s-media-cache-ak0.pinimg.com/originals/57/eb/2b/57eb2b7ae61914ed41cab8d352341982.jpg"
  ),
  Comic(
    id: 7,
    title: "Test 7",
    issueNumber: 1,
    description: fakeText,
    pageCount: 185,
    thumbnail: "https://cdn.pastemagazine.com/www/system/images/photo_albums/bestcomiccovers2016/large/blackhammer2-deanormston.png?1384968217",
    cover:"https://cdn.pastemagazine.com/www/system/images/photo_albums/bestcomiccovers2016/large/blackhammer2-deanormston.png?1384968217"
  )
]

private let fakeText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
