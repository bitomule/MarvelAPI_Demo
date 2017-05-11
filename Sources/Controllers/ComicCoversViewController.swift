//
//  ComicCoversViewController.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit
import Reusable
import ReactiveCocoa
import ReactiveSwift

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
    
    title = L10n.comicsCoversTitle.string
    
    collectionView.register(cellType: ComicCoverCollectionViewCell.self)
    
    collectionView.reactive.reloadData <~ viewModel.outputs.itemsReloaded
    
    viewModel.outputs.itemsAdded.observeValues {[weak self] addedCount in
      var indexPaths = [IndexPath]()
      for index in 0...addedCount{
        indexPaths.append(IndexPath(item: index, section: 0))
      }
      self?.collectionView.insertItems(at: indexPaths)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.reloadData()
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    collectionView.collectionViewLayout.invalidateLayout()
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
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width * 0.5, height: collectionView.bounds.height * 0.3)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    appCoordinator.router.navigate(from: self, to: Routes.comicDetail(comicId:viewModel.outputs.itemAt(index: indexPath.row).id), style: .push).start()
  }
  
}

