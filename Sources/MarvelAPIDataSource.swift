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
  case comics(privateAPIKey:String,publicAPIKey:String,characters:[String],limit:Int?,offset:Int?)
  case comic(privateAPIKey:String,publicAPIKey:String,id:Int)
}

extension MarvelService: TargetType {
  var baseURL: URL { return URL(string: "https://gateway.marvel.com:443/v1")! }
  
  
  var path: String {
    switch self {
    case let .comics(_,_,_,_,_):
      return "/public/comics"
    case .comic(_,_,_):
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
    case let .comics(privateAPIKey,publicAPIKey,characters,limit,offset):
      let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
      return [
        "ts":timeStamp,
        "hash":MarvelHashGenerator.generateHash(timestamp: timeStamp, privateKey: privateAPIKey, publicKey: publicAPIKey),
        "format":"comic",
        "limit":limit,
        "offset":offset,
        "apikey":publicAPIKey
      ]
    case .comic(_,_,_):
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
  
  //fileprivate let marvelService = ReactiveSwiftMoyaProvider<MarvelService>(plugins: [NetworkLoggerPlugin(verbose: true)])
  fileprivate let marvelService = ReactiveSwiftMoyaProvider<MarvelService>()
  
  let publicAPIKey:String
  let privateAPIKey:String
  
  init(){
    if let path = Bundle.main.path(forResource: "keys", ofType: "plist") ,
      let publicKey = NSDictionary(contentsOfFile: path)?.value(forKey: "marvelPublicAPIKey") as? String,
      let privateKey = NSDictionary(contentsOfFile: path)?.value(forKey: "marvelPrivateAPIKey") as? String{
      publicAPIKey = publicKey
      privateAPIKey = privateKey
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
    return marvelService.request(.comics(privateAPIKey: privateAPIKey,publicAPIKey: publicAPIKey,characters: characters, limit: limit, offset: offset)).mapArray(type: Comic.self, forKeyPath: "data.results").mapRequestError()
  }
}


extension MarvelAPIDataSource:ComicDetailDataSource{
  
  func getComic(id:Int)->SignalProducer<Comic,DataSourceError>{
    return marvelService.request(.comic(privateAPIKey: privateAPIKey,publicAPIKey: publicAPIKey,id: id)).mapObject(type: Comic.self).mapRequestError()
  }
}

