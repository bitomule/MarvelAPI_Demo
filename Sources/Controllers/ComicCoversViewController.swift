//
//  ComicCoversViewController.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

class ComicCoversViewController: UIViewController {
  
  let appCoordinator:AppCoordinatorType
  let viewModel: ComicCoversViewModelType
  
  init(appCoordinator:AppCoordinatorType,viewModel: ComicCoversViewModelType) {
    self.appCoordinator = appCoordinator
    self.viewModel = viewModel
    super.init(nibName: "\(ComicCoversViewController.self)", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
