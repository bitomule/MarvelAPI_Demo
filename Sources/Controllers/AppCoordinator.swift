//
//  AppCoordinator.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

protocol AppCoordinatorType{
  var router:RouterType {get}
}

final class AppCoordinator{
  
  let window:UIWindow
  var router:RouterType!
  
  var rootViewController: UIViewController?{
    get{
      return window.rootViewController
    }
  }
  
  init(window:UIWindow){
    self.window = window
    self.router = Router(appCoordinator: self)
  }
  
  func start(){
    //let mainViewController = Routes.first.controllerWith(appCoordinator: self)
    //window.rootViewController = mainViewController
    //window.makeKeyAndVisible()
  }
}
