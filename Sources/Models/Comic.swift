//
//  Comic.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Gloss

struct Comic{
  let id:Int
  let title:String
  let issueNumber:Double
  let description:String
  let pageCount:Int
  let thumbnail:String?
  let images:[String]
}

extension Comic:Decodable{
  init?(json: JSON) {
    print(json)
    guard
      let id:Int = "id" <~~ json,
      let title:String = "title" <~~ json,
      let issueNumber:Double = "issueNumber" <~~ json,
      let pageCount:Int = "pageCount" <~~ json
      else {return nil}
    self.id = id
    self.title = title
    self.description = ("description" <~~ json) ?? ""
    self.issueNumber = issueNumber
    self.pageCount = pageCount
    self.thumbnail = "thumbnail.path" <~~ json
    self.images = ("images" <~~ json) ?? []
  }
}
