//
//  CALConstraints.swift
//  CALConstraints
//
//  Created by Calvin Chueh on 11/10/18.
//  Copyright © 2018 Calvin. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

  class func pixelHeightPoints() -> CGFloat {
    return 1.0 / UIScreen.main.scale
  }

}

extension UIView {

  func displayBorder(_ color: UIColor) {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = color.cgColor
  }

  func addToAndConstrain(insideSuperview superview: UIView) {
    addToAndConstrain(insideSuperview: superview, withAllAroundMargin: 0)
  }

  func addToAndConstrain(insideSuperview superview: UIView, withAllAroundMargin margin: CGFloat) {
    superview.addSubview(self)
    superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview,
                                               attribute: .top, multiplier: 1.0, constant: margin))
    superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview,
                                               attribute: .bottom, multiplier: 1.0, constant: -margin))
    superview.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview,
                                               attribute: .left, multiplier: 1.0, constant: margin))
    superview.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview,
                                               attribute: .right, multiplier: 1.0, constant: -margin))
  }

  func addToAndConstrain(insideSuperView superview: UIView,
                         withConstraintAttribute attribute: CALLayoutAttribute) {
    superview.addSubview(self)
    addConstraint(toSuperView: superview, withAttribute: attribute)
  }

  func addToAndConstrain(insideSuperView superview: UIView,
                         withConstraintAttributes attributes: [CALLayoutAttribute],
                         andRelationshipAttributes relations: [CALLayoutRelationship] = [],
                         forSibling sibling: UIView? = nil) {
    superview.addSubview(self)
    attributes.forEach { addConstraint(toSuperView: superview, withAttribute: $0) }
    if let sibling = sibling {
      relations.forEach { addConstraint(to: superview, for: sibling, with: $0) }
    }
  }

  func addToAndConstrainToSafeArea(insideSuperView superview: UIView, withConstraintAttributes attributes: [CALLayoutAttribute]) {
    superview.addSubview(self)
    attributes.forEach { attribute in
      var constant: CGFloat = 0
      switch attribute {
      case let .kTop(val),
           let .kBottom(val):
        constant = val
        fallthrough
      case .top,
           .bottom:
        addConstraintToSafeArea(toSuperView: superview, with: attribute, and: constant)
      default:
        addConstraint(toSuperView: superview, withAttribute: attribute)
      }
    }
  }

  private func addConstraintToSafeArea(toSuperView view: UIView, with attribute: CALLayoutAttribute, and constant: CGFloat) {
    if #available(iOS 11.0, *) {
      let guide = view.safeAreaLayoutGuide
      view.addConstraint(NSLayoutConstraint(item: self, attribute: attribute.appleConstraint, relatedBy: .equal, toItem: guide,
                                            attribute: attribute.appleConstraint, multiplier: 1.0, constant: constant))
    } else {
      view.addConstraint(NSLayoutConstraint(item: self, attribute: attribute.appleConstraint, relatedBy: .equal, toItem: view,
                                            attribute: attribute.appleConstraint, multiplier: 1.0, constant: constant))
    }
  }

  private func addConstraint(toSuperView view: UIView, withAttribute attribute: CALLayoutAttribute) {
    switch attribute {
    case let .kLeft(val),
         let .kRight(val),
         let .kTop(val),
         let .kBottom(val),
         let .kCenterX(val),
         let .kCenterY(val):
      view.addConstraint(NSLayoutConstraint(item: self, attribute: attribute.appleConstraint, relatedBy: .equal, toItem: view,
                                            attribute: attribute.appleConstraint, multiplier: 1.0, constant: val))
    case let .kHeight(val),
         let .kWidth(val):
      view.addConstraint(NSLayoutConstraint(item: self, attribute: attribute.appleConstraint, relatedBy: .equal, toItem: nil,
                                            attribute: .notAnAttribute, multiplier: 1.0, constant: val))
    case .left,
         .right,
         .top,
         .bottom,
         .centerX,
         .centerY:
      view.addConstraint(NSLayoutConstraint(item: self, attribute: attribute.appleConstraint, relatedBy: .equal, toItem: view,
                                            attribute: attribute.appleConstraint, multiplier: 1.0, constant: 0.0))
    }
  }

  private func addConstraint(to superview: UIView, for sibling: UIView, with relation: CALLayoutRelationship) {

    var constant: CGFloat = 0

    switch relation {
    case let .custom(first, second, val):
      superview.addConstraint(
        NSLayoutConstraint(
          item: self,
          attribute: first,
          relatedBy: .equal,
          toItem: sibling,
          attribute: second,
          multiplier: 1.0,
          constant: val
        )
      )
      return
    case let .align(attribute):
      superview.addConstraint(
        NSLayoutConstraint(
          item: self,
          attribute: attribute,
          relatedBy: .equal,
          toItem: sibling,
          attribute: attribute,
          multiplier: 1.0,
          constant: 0
        )
      )
      return
    case .above,
         .below,
         .leftOf,
         .rightOf:
      break
    case let .kAbove(val),
         let .kBelow(val),
         let .kLeftOf(val),
         let .kRightOf(val):
      constant = val
    }
    superview.addConstraint(
      NSLayoutConstraint(
        item: self,
        attribute: relation.appleConstraint,
        relatedBy: .equal,
        toItem: sibling,
        attribute: relation.appleConstraint.opposite,
        multiplier: 1.0,
        constant: constant
      )
    )
  }

  func removeConstraint(_ constraint: NSLayoutConstraint?) {
    if let c = constraint {
      removeConstraint(c)
    }
  }

}

private extension NSLayoutConstraint.Attribute {

  var opposite: NSLayoutConstraint.Attribute {
    switch self {
    case .bottom:
      return .top
    case .top:
      return .bottom
    case .left:
      return .right
    case .right:
      return .bottom
    default:
      preconditionFailure("Update this if you want more available")
    }
  }

}
