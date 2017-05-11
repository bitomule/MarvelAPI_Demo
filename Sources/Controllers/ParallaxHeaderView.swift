//
//  ParallaxHeaderView.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit
import Foundation
import ReactiveSwift

final class ParallaxHeaderView: UIView {
  
  @IBInspectable var baseHeightScreen:CGFloat{
    get{
      return _baseHeightScreen
    }
    set(newValue){
      _baseHeightScreen = fmax(newValue, 480)
    }
  }
  
  private var _baseHeightScreen:CGFloat = 480
  
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  
  /// The non-negative maximum height for the bar. The default value is **44.0**.
  var maximumBarHeight: CGFloat {
    get {
      return _maximumBarHeight
    }
    set (newMaximumBarHeight) {
      _maximumBarHeight = fmax(newMaximumBarHeight, 0.0)
    }
  }
  var _maximumBarHeight: CGFloat = 44.0
  
  /// The non-negative minimum height for the bar. The default value is **20.0**.
  @IBInspectable var minimumBarHeight: CGFloat {
    get {
      return _minimumBarHeight
    }
    set (newMinimumBarHeight) {
      _minimumBarHeight = fmax(newMinimumBarHeight, 0.0)
    }
  }
  var _minimumBarHeight: CGFloat = 20.0
  
  weak var delegate:ParallaxHeaderDelegate?
  
  /**
   The current progress, representing how much the bar has shrunk. *progress == 0.0* puts the bar at its maximum height. *progress == 1.0* puts the bar at its minimum height. The default value is **0.0**.
   */
  var progress: CGFloat {
    get {
      return _progress
    }
    set (newProgress) {
      _progress = fmax(newProgress,0)
      delegate?.updateFlexibleHeaderSubviews(_progress)
      heightConstraint.constant = interpolate(from: minimumBarHeight, to: maximumBarHeight, withProgress: _progress)
    }
  }
  var _progress: CGFloat = 0.0
  
  var baseBottomInset:CGFloat = 0
  
  //var updatingHeightEnabled = true
  
  override func awakeFromNib() {
    super.awakeFromNib()
    maximumBarHeight = (heightConstraint.constant / _baseHeightScreen) * UIScreen.main.bounds.height
    heightConstraint.constant = maximumBarHeight
    baseBottomInset = scrollView.contentInset.bottom
    applyMaxHeightToScrollView()
  }
  
  var firstLayout = true
  
  override func layoutSubviews() {
    super.layoutSubviews()
    applyMaxHeightToScrollView()
  }
  
  var contentSpaceToBottom:CGFloat{
    get{
      return fmax(scrollView.bounds.height - heightConstraint.constant - scrollView.contentSize.height, 0)
    }
  }
  
  func applyMaxHeightToScrollView(){
    self.scrollView.contentInset = UIEdgeInsets(top: maximumBarHeight, left: self.scrollView.contentInset.left, bottom: baseBottomInset + contentSpaceToBottom, right: self.scrollView.contentInset.right)
  }
  
  func updateProgress(){
    progress = 1 - (scrollView.contentOffset.y + scrollView.contentInset.top) / (maximumBarHeight - minimumBarHeight)
  }
}

extension ParallaxHeaderView{
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    progress = 1 - (scrollView.contentOffset.y + scrollView.contentInset.top) / (maximumBarHeight - minimumBarHeight)
  }
}

func interpolate(from fromValue: CGFloat, to toValue: CGFloat, withProgress progress: CGFloat) -> CGFloat {
  return fromValue - ((fromValue - toValue) * progress)
}

protocol ParallaxHeaderDelegate:class{
  func updateFlexibleHeaderSubviews(_ progress:CGFloat)
}
