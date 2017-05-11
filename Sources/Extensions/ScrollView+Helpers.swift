//
//  ScrollView+Helpers.swift
//  WallapopMarvel
//
//  Created by David Collado on 11/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

extension UIScrollView {
  
  var isAtTop: Bool {
    return contentOffset.y <= verticalOffsetForTop
  }
  
  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }
  
  func isCloseToBottom(margin:CGFloat)->Bool{
    return contentOffset.y >= (verticalOffsetForBottom - margin)
  }
  
  var verticalOffsetForTop: CGFloat {
    let topInset = contentInset.top
    return -topInset
  }
  
  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }
  
}
