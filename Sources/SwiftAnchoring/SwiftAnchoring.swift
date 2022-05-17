//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//

import class UIKit.UIView
import struct UIKit.CGFloat
import UIKit

public extension UIView {
  
  // Convenience methods for adding a subview that also returns it such that you can asign it
  // directly to a weak var without it being deallocated. Less boilerplate mainly
  @discardableResult
  func addingSubview<T: UIView>(_ subView: T) -> T {
    subView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subView)
    return subView
  }
  
  // Use this method to add subview of a specific type
  // view must implement init() method with no parameters
  @discardableResult
  func addingSubview<T: UIView>(_ subViewType: T.Type) -> T {
    let instance = subViewType.init()
    instance.translatesAutoresizingMaskIntoConstraints = false
    addSubview(instance)
    return instance
  }
  
  // Convenience methods for setting up constraints
  
  @discardableResult
  func anchor(_ anchors: Anchor..., with view: UIView, safe: Bool = false) -> UIView {
    for anchor in anchors {
      fetchAnchorsAndActivate(source: anchor, targetView: view, safe: safe)
    }
    return self
  }
  
  @discardableResult
  func anchor(_ anchor: HorizontalAnchor, with view: UIView, _ target: TargetHorizontalAnchor) -> UIView {
    if let simpleTargetType = getSimpleAnchor(forType: target) {
      fetchAnchorsAndActivate(source: anchor, targetView: view, simpleTargetType: simpleTargetType, safe: false)
    }
    
    return self
  }
  
  @discardableResult
  func anchor(_ anchor: VerticalAnchor, with view: UIView, _ target: TargetVerticalAnchor) -> UIView {
    if let simpleTargetType = getSimpleAnchor(forType: target) {
      fetchAnchorsAndActivate(source: anchor, targetView: view, simpleTargetType: simpleTargetType, safe: false)
    }
    
    return self
  }
  
  // Main reason why this wasn't made into a discardable UIView returning method is because
  // calling shape should be the last thing you do in your view setup (for consistency)
  func shape(_ dimensions: DimensionalAnchor...) {
    translatesAutoresizingMaskIntoConstraints = false
    
    for dimension in dimensions {
      switch dimension {
        case .width(let constant):
          activateDimensional(anchor: widthAnchor, constant: constant)
        case .height(let constant):
          activateDimensional(anchor: heightAnchor, constant: constant)
        case .square(let constant):
          activateDimensional(anchor: widthAnchor, constant: constant)
          activateDimensional(anchor: heightAnchor, constant: constant)
        case .aspectRatio(let multiplier):
          handleAspectRatio(multiplier: multiplier)
      }
    }
  }
  
  // MARK: - Private
  
  // Only once cast can be successful, so whichever cast can be done will activate the contraints.
  // Also only anchors of the same type (x, y, dimension) can be linked together
  internal func activate(source: AnyObject, target: AnyObject, value: CGFloat) {
    if let horizontalSource = source as? NSLayoutXAxisAnchor,
       let horizontalTarget = target as? NSLayoutXAxisAnchor {
      let constraint = horizontalSource.constraint(equalTo: horizontalTarget, constant: value)
      constraint.isActive = true
    } else if let verticalSource = source as? NSLayoutYAxisAnchor,
              let verticalTarget = target as? NSLayoutYAxisAnchor {
      let constraint = verticalSource.constraint(equalTo: verticalTarget, constant: value)
      constraint.isActive = true
    } else if let dimensionSource = source as? NSLayoutDimension,
              let dimensionTarget = target as? NSLayoutDimension {
      let constraint = dimensionSource.constraint(equalTo: dimensionTarget, constant: value)
      constraint.isActive = true
    } else {
      print("Unexpected constraints... what happened?")
    }
  }
  
  internal func activateDimensional(anchor: NSLayoutDimension, constant: CGFloat) {
    anchor.constraint(equalToConstant: constant).isActive = true
  }
  
  // TODO: implement more safety checks
  internal func checkIfSameType(_ firstAnchor: AnchorType, _ secondAnchor: AnchorType, constant: CGFloat) {}
  internal func checkIfRelated(to view: UIView) {}
  
  internal func fetchAnchorsAndActivate(source sourceAnchor: BaseAnchor,
                                        targetView: UIView,
                                        simpleTargetType parameterTargetType: SimpleAnchorType? = nil,
                                        safe: Bool)
  {
    for simpleSourceType in sourceAnchor.type.simpleAnchorsTypes {
      let sourceNativeAnchor = getNativeAnchor(forType: simpleSourceType, safe: safe)
      
      // Special cases (leftToRight, topToBottom) have a separate targetAnchor to
      // identify which part of the target view they're connecting to
      let simpleTargetAnchorType: SimpleAnchorType = parameterTargetType ?? sourceAnchor.type.targetAnchor ?? simpleSourceType
      
      let targetNativeAnchor = targetView.getNativeAnchor(forType: simpleTargetAnchorType, safe: safe)
      
      // Unlike normal constraints, we only have positive constraints
      let value: CGFloat
      if simpleSourceType == .right && simpleTargetAnchorType == .right ||
          simpleSourceType == .bottom && simpleTargetAnchorType == .bottom
      {
        value = -sourceAnchor.value
      } else {
        value = sourceAnchor.value
      }
      activate(source: sourceNativeAnchor, target: targetNativeAnchor, value: value)
    }
  }
  
  // This method returns an AnyObject because there is no way to group elements of type NSLayoutConstraint<T>
  // There's 3 underlying types used here: NSLayoutXAxisAnchor, NSLayoutYAxisAnchor & NSLayoutDimension
  internal func getNativeAnchor(forType type: SimpleAnchorType, safe: Bool) -> AnyObject {
    switch type {
      case .bottom:
        return safe ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
      case .centerX:
        return safe ? safeAreaLayoutGuide.centerXAnchor : centerXAnchor
      case .centerY:
        return safe ? safeAreaLayoutGuide.centerYAnchor : centerYAnchor
      case .height:
        return safe ? safeAreaLayoutGuide.heightAnchor : heightAnchor
      case .left:
        return safe ? safeAreaLayoutGuide.leftAnchor : leftAnchor
      case .right:
        return safe ? safeAreaLayoutGuide.rightAnchor : rightAnchor
      case .top:
        return safe ? safeAreaLayoutGuide.topAnchor : topAnchor
      case .width:
        return safe ? safeAreaLayoutGuide.widthAnchor : widthAnchor
    }
  }
  
  internal func getSimpleAnchor(forType anchor: BaseAnchor) -> SimpleAnchorType? {
    switch anchor.type {
      case .simple(let simpleAnchor):
        return simpleAnchor
      default:
        print("Tried to get simple anchor type. Got complex instead.")
        return nil
    }
  }
  
  internal func handleAspectRatio(multiplier: CGFloat) {
    for constraint in constraints {
      switch constraint.firstAttribute {
        case .width:
          heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier).isActive = true
          return
        case .height:
          widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier).isActive = true
          return
        default:
          continue
      }
    }
    print("Warning: trying to set aspect ratio without an existing height or width constraint")
  }
}
