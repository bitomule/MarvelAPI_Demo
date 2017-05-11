//
//  NavigationController+Completion.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

extension UINavigationController {
  public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping (Void) -> Void) {
    pushViewController(viewController, animated: animated)
    guard animated, let coordinator = transitionCoordinator else {
      completion()
      return
    }
    
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
    
  }
}
