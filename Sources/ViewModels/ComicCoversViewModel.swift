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

}

protocol ComicCoversInput{
}

protocol ComicCoversViewModelType{
  var outputs:ComicCoversOutput {get}
  var inputs:ComicCoversInput {get}
}

final class ComicCoversViewModel:ComicCoversViewModelType,ComicCoversInput,ComicCoversOutput{
  
  
  var inputs: ComicCoversInput { return self }
  var outputs: ComicCoversOutput { return self }
  
  // Outputs
  

  
  //Inputs
  
  
  let dataSource:ComicCoversDataSource
  init(dataSource:ComicCoversDataSource = InMemoryDataSource()){
    self.dataSource = dataSource
    
  }
}
