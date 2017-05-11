//
//  AppCoordinator.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

protocol AppCoordinatorType:class{
  var router:RouterType! {get}
}

final class AppCoordinator:AppCoordinatorType{
  
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
    let mainViewController = Routes.comicCovers.controllerWith(appCoordinator: self)
    window.rootViewController = mainViewController
    window.makeKeyAndVisible()
  }
}
