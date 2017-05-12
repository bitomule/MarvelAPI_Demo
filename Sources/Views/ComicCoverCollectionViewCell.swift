//
//  ComicCoverCollectionViewCell.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class ComicCoverCollectionViewCell: UICollectionViewCell,NibReusable {
  
  @IBOutlet weak var coverView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setup(imageUrl:String){
    if let url = URL(string: imageUrl){
      coverView.kf.setImage(with: url, placeholder: Asset.Loading.image, options: nil, progressBlock: nil, completionHandler: nil)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    coverView.kf.cancelDownloadTask()
    coverView.image = nil
  }
  
  override var isSelected: Bool {
    didSet {
      coverView.alpha = isSelected ? 0.8 : 1
    }
  }
  
  override var isHighlighted: Bool{
    didSet{
      coverView.alpha = isHighlighted ? 0.8 : 1
    }
  }
  
}
