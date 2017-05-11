//
//  MarvelHashGenerator.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import Foundation
import CryptoSwift

class MarvelHashGenerator {
  
  static func generateHash(timestamp: Int, privateKey: String, publicKey: String) -> String {
    let combinedHash = "\(timestamp)\(privateKey)\(publicKey)"
    return combinedHash.md5()
  }
  
}
