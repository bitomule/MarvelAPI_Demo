//
//  ReactiveSwift+Helpers.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducerProtocol{
  
  public func ignoreErrors(replacementValue: Self.Value? = nil) -> SignalProducer<Self.Value, NoError> {
    return self.flatMapError { error in
      return replacementValue.map(SignalProducer.init) ?? .empty
    }
  }
  
  public func redirectErrorsToObserver(_ observer: Observer<Self.Error, NoError>, replacementValue: Self.Value? = nil) -> SignalProducer<Self.Value, NoError> {
    return self.flatMapError { error in
      observer.send(value:error)
      
      return replacementValue.map(SignalProducer.init) ?? .empty
    }
  }
}
