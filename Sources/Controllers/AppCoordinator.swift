//
//  AppCoordinator.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

final class AppCoordinator{
  
  let window:UIWindow
  
  var rootViewController: UIViewController?{
    get{
      return window.rootViewController
    }
  }
  
  init(window:UIWindow){
    self.window = window
  }
  
  func start(){
    
  }
}
