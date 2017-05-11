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
  
  
  //Inputs
  
  let dataSource:ComicDetailDataSource
  
  init(dataSource:ComicDetailDataSource = InMemoryDataSource()){
    self.dataSource = dataSource
    
    
    
  }
}
