//
//  ComicCoversViewController.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit
import Reusable

class ComicCoversViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
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
    collectionView.register(cellType: ComicCoverCollectionViewCell.self)
  }
  
}

// MARK: - CollectionViewDataSource

extension ComicCoversViewController:UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return viewModel.outputs.itemsCount.value
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    let cell:ComicCoverCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    if let url = viewModel.outputs.itemAt(index: indexPath.row).thumbnail{
      cell.setup(imageUrl: url)
    }
    return cell
  }

}


// MARK: - FlowLayoutDelegate

extension ComicCoversViewController:UICollectionViewDelegateFlowLayout{
  
}

