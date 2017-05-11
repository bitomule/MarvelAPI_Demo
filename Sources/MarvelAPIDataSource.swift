//
//  MarvelAPIDataSource.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import ReactiveSwift
import ReactiveMoya
import Moya
import Alamofire
import ReactiveMoyaGloss
import Gloss
import AwesomeCache
import Result

let MARVELAPIKEY = ""

private enum MarvelService {
  case comics(characters:[String],limit:Int?,offset:Int?)
  case comic(id:Int)
}

extension MarvelService: TargetType {
  var baseURL: URL { return URL(string: "https://gateway.marvel.com:443/v1")! }
  
  var path: String {
    switch self {
    case let .comics(_,_,_):
      return "/public/comics"
    case .comic(let id):
      return "/details/json"
    }
  }
  var method: Moya.Method {
    switch self {
    case .comics,.comic:
      return .get
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    case let .comics(characters,limit,offset):
      return ["format":"comic","limit":limit,"offset":offset,"apikey":MARVELAPIKEY]
    case .comic(let id):
      return [:]
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
    case .comics,.comic:
      return URLEncoding.default // Send parameters in URL
    }
  }
  var sampleData: Data {
    switch self {
    case .comics,.comic:
      return "{\"id\": \"123\", \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".data(using: String.Encoding.utf8)!
    }
  }
  
  var task: Task {
    switch self {
    case .comics,.comic:
      return .request
    }
  }
}

final class MarvelAPIDataSource{
  
  fileprivate let marvelService = ReactiveSwiftMoyaProvider<MarvelService>(plugins: [NetworkLoggerPlugin(verbose: true)])
  
}


// MARK: - Helpers


extension SignalProducerProtocol where Self.Error == MoyaError{
  fileprivate func mapRequestError() -> ReactiveSwift.SignalProducer<Self.Value, DataSourceError>{
    return self.mapError { apiError -> DataSourceError in
      switch apiError{
      case .statusCode(_):
        return DataSourceError(title: nil, description: nil)
      case .jsonMapping(_):
        return DataSourceError(title: nil, description: nil)
      default:
        return DataSourceError(title: nil, description: nil)
      }
    }
  }
}



// MARK: - Datasource implementation


extension MarvelAPIDataSource:ComicCoversDataSource{
  func getComics(characters:[String],limit:Int?,offset:Int?)->SignalProducer<[Comic],DataSourceError>{
    print(MarvelService.comics(characters: characters, limit: limit, offset: offset).parameters)
    marvelService.request(.comics(characters: characters, limit: limit, offset: offset)).ignoreErrors().startWithValues { response in
      print(response)
    }
    
    return marvelService.request(.comics(characters: characters, limit: limit, offset: offset)).mapArray(type: Comic.self, forKeyPath: "data.results").on( failed: { error in
      print(error)
    }).mapRequestError()
  }
}


extension MarvelAPIDataSource:ComicDetailDataSource{
  
  func getComic(id:Int)->SignalProducer<Comic,DataSourceError>{
    return marvelService.request(.comic(id: id)).mapObject(type: Comic.self).mapRequestError()
  }
}

