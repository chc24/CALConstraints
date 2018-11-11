//
//  CALRelationshipAttribute.swift
//  CALConstraints
//
//  Created by Calvin Chueh on 11/10/18.
//  Copyright © 2018 Calvin. All rights reserved.
//

import UIKit

enum CALLayoutRelationship {
  case kBelow(CGFloat)
  case kAbove(CGFloat)
  case below
  case above

  case kLeftOf(CGFloat)
  case kRightOf(CGFloat)
  case leftOf
  case rightOf

  case align(NSLayoutConstraint.Attribute)
  case custom(NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute, CGFloat)

  // the constraint of the first parameter you are interested
  // in attaching to the sibling.
  var appleConstraint: NSLayoutConstraint.Attribute {
    switch self {
    case .above,
         .kAbove(_):
      return .bottom
    case .below,
         .kBelow(_):
      return .top
    case .leftOf,
         .kLeftOf(_):
      return .right
    case .rightOf,
         .kRightOf(_):
      return .left
    default:
      preconditionFailure("Not something that has an opposite")
    }
  }

}
