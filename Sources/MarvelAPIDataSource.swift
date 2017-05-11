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


private enum MarvelService {
  case comics(apiKey:String,characters:[String],limit:Int?,offset:Int?)
  case comic(apiKey:String,id:Int)
}

extension MarvelService: TargetType {
  var baseURL: URL { return URL(string: "https://gateway.marvel.com:443/v1")! }
  
  
  var path: String {
    switch self {
    case let .comics(_,_,_,_):
      return "/public/comics"
    case .comic(_,_):
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
    case let .comics(apiKey,characters,limit,offset):
      return ["format":"comic","limit":limit,"offset":offset,"apikey":apiKey]
    case .comic(_,_):
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
  
  let apiKey:String
  
  init(){
    if let path = Bundle.main.path(forResource: "keys", ofType: "plist") ,
      let key = NSDictionary(contentsOfFile: path)?.value(forKey: "marvelAPIKey") as? String{
      apiKey = key
    }else{
      fatalError("Please provide marvel api key in keys plist")
    }
  }
  
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
    return marvelService.request(.comics(apiKey: apiKey,characters: characters, limit: limit, offset: offset)).mapArray(type: Comic.self, forKeyPath: "data.results").mapRequestError()
  }
}


extension MarvelAPIDataSource:ComicDetailDataSource{
  
  func getComic(id:Int)->SignalProducer<Comic,DataSourceError>{
    return marvelService.request(.comic(apiKey: apiKey,id: id)).mapObject(type: Comic.self).mapRequestError()
  }
}

