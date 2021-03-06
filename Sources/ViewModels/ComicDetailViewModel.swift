//
//  ComicDetailViewModel.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import Result

protocol ComicDetailOutput{
  var title:MutableProperty<String?> {get}
  var description:MutableProperty<String?> {get}
  var imageUrl:MutableProperty<URL?> {get}
  var issueNumber:MutableProperty<String?> {get}
}

protocol ComicDetailInput{

}

protocol ComicDetailViewModelType{
  var outputs:ComicDetailOutput {get}
  var inputs:ComicDetailInput {get}
}

final class ComicDetailViewModel:ComicDetailViewModelType,ComicDetailInput,ComicDetailOutput{
  
  
  var inputs: ComicDetailInput { return self }
  var outputs: ComicDetailOutput { return self }
  
  // Outputs
  let title:MutableProperty<String?> = MutableProperty(nil)
  let description:MutableProperty<String?> = MutableProperty(nil)
  let imageUrl:MutableProperty<URL?> = MutableProperty(nil)
  let issueNumber:MutableProperty<String?> = MutableProperty(nil)
  
  //Inputs
  
  let comic:MutableProperty<Comic?> = MutableProperty(nil)
  let dataSource:ComicDetailDataSource
  
  init(comicId:Int,dataSource:ComicDetailDataSource = MarvelAPIDataSource()){
    self.dataSource = dataSource
    
    comic <~ dataSource.getComic(id: comicId).ignoreErrors()
    
    title <~ comic.map{$0?.title}
    
    description <~ comic.map{$0?.description}
    
    issueNumber <~ comic.map{$0?.issueNumber}.producer.skipNil().map{String(Int($0))}
    
    imageUrl <~ comic.producer.skipNil().map{$0.cover}.skipNil().map({ coverUrl -> URL? in
      return URL(string: coverUrl)
    })
    
  }
}
