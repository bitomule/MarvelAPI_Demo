//
//  Router.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

enum PresentationStyle{
  case push
  case modal
}

enum NavigationError:Error{
  case noNavigationControllerFound
  case alreadyNavigating
}

protocol RouterNavigable{
  func controllerWith(appCoordinator:AppCoordinatorType)->UIViewController
}

protocol RouterType:class{
  func navigate(from:UIViewController,to:RouterNavigable,style:PresentationStyle) -> SignalProducer<UIViewController,NavigationError>
}

final class Router:RouterType{
  
  weak var appCoordinator:AppCoordinatorType!
  var navigating = false
  
  init(appCoordinator:AppCoordinatorType){
    self.appCoordinator = appCoordinator
  }
  
  func navigate(from:UIViewController,to:RouterNavigable,style:PresentationStyle) -> SignalProducer<UIViewController,NavigationError>{
    return SignalProducer<UIViewController,NavigationError>{ observer,_ in
      guard !self.navigating else {
        observer.send(error:.alreadyNavigating)
        return
      }
      
      self.navigating = true
      
      let toControllerSetup = to.controllerWith(appCoordinator: self.appCoordinator)
      
      switch style {
      case .modal:
        from.present(toControllerSetup, animated: true, completion: {
          self.navigating = false
          observer.send(value:toControllerSetup)
          observer.sendCompleted()
        })
      case .push:
        guard let navigationController = from.navigationController else {
          self.navigating = false
          observer.send(error: .noNavigationControllerFound)
          return
        }
        navigationController.pushViewController(toControllerSetup, animated: true, completion: {
          self.navigating = false
          observer.send(value:toControllerSetup)
          observer.sendCompleted()
        })
      }
    }
  }
}

enum Routes{
  case comicCovers
  case comicDetail
}

extension Routes:RouterNavigable{
  func controllerWith(appCoordinator:AppCoordinatorType)->UIViewController{
    switch self {
    case .comicCovers:
      let vm = ComicCoversViewModel()
      let vc = ComicCoversViewController(appCoordinator: appCoordinator, viewModel: vm)
      return UINavigationController(rootViewController: vc)
    case .comicDetail:
      let vm = ComicDetailViewModel()
      let vc = ComicDetailViewController(appCoordinator: appCoordinator,viewModel:vm)
      return vc
    }
  }
}
