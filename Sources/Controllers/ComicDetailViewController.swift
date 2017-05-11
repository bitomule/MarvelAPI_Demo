//
//  ComicDetailViewController.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {
  
  @IBOutlet weak var header: ParallaxHeaderView!
  @IBOutlet weak var backButton: UIButton!
  
  let appCoordinator:AppCoordinatorType
  let viewModel:ComicDetailViewModelType
  
  init(appCoordinator:AppCoordinatorType,viewModel:ComicDetailViewModelType) {
    self.appCoordinator = appCoordinator
    self.viewModel = viewModel
    super.init(nibName: "\(ComicDetailViewController.self)", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    header.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateFlexibleHeaderSubviews(header.progress)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.alpha = 1
    backButton.alpha = 0
  }
  
}

extension ComicDetailViewController:UIScrollViewDelegate{
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    header.scrollViewDidScroll(scrollView)
  }
}

extension ComicDetailViewController:ParallaxHeaderDelegate{
  func updateFlexibleHeaderSubviews(_ progress: CGFloat) {

    backButton.alpha = interpolate(from: 0, to: 1, withProgress: progress / 0.5)
    navigationController?.navigationBar.alpha = interpolate(from: 1, to: 0, withProgress: progress / 0.5)
  }

}
