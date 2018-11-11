//
//  CALLayoutAttribute.swift
//  CALConstraints
//
//  Created by Calvin Chueh on 11/10/18.
//  Copyright © 2018 Calvin. All rights reserved.
//

import UIKit

enum CALLayoutAttribute {
  case kHeight(CGFloat)
  case kWidth(CGFloat)
  case kLeft(CGFloat)
  case kRight(CGFloat)
  case kTop(CGFloat)
  case kBottom(CGFloat)
  case kCenterX(CGFloat)
  case kCenterY(CGFloat)
  case left
  case right
  case top
  case bottom
  case centerX
  case centerY

  var appleConstraint: NSLayoutConstraint.Attribute {
    switch self {
    case .kHeight(_):
      return .height
    case .kWidth(_):
      return .width
    case .kLeft(_),
         .left:
      return .left
    case .kRight(_),
         .right:
      return .right
    case .kTop(_),
         .top:
      return .top
    case .kBottom(_),
         .bottom:
      return .bottom
    case .kCenterX(_),
         .centerX:
      return .centerX
    case .kCenterY(_),
         .centerY:
      return .centerY
    }
  }

}
