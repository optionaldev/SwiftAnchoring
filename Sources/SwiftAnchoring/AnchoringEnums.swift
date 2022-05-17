//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct UIKit.CGFloat

// Main reasons why dimensional anchor is an enum and the rest of them are classes & protocols:
// 1) For anchors like '.top', '.leading', '.trailing', having an implicit constant value of 0 makes sense
//    and it's a common case to simply not have spacing between the two elements you're constraining
//    On the flipside, how often would you constrain '.width' with constant of 0? Probably almost never
//    In XCode (at least on 11.2.1), code suggestion puts enum cases at the very top, while in
//    classes, static vars come at the very top and methods get places below them
//
// 2) Vertical and horizontal constraints are sometimes used as a group to allow inputs of both types
//    while other times they are specifically used separate to prevent misuse such as
//    .bottom to .left, .centerX to .centerY, .left to .leftToRight, etc

public enum DimensionalAnchor {
    case width(_ constant: CGFloat)
    case height(_ constant: CGFloat)
    case square(_ constant: CGFloat)
    case aspectRatio(_ multiplier: CGFloat)
}

public enum SimpleAnchorType: Equatable {
    case bottom
    case centerX
    case centerY
    case height
    case left
    case right
    case top
    case width
}

public enum SpecialAnchorType: Equatable {
    case leftToRight
    case topToBottom
}

public enum AnchorType {
    case simple(_ simpleType: SimpleAnchorType)
    case special(_ specialType: SpecialAnchorType)
    case center
    case inner
    case sides
    case topAndBottom
    
    var targetAnchor: SimpleAnchorType? {
        switch self {
        case .special(let specialType):
            switch specialType {
            case .leftToRight:
                return .right
            case .topToBottom:
                return .bottom
            }
        default:
            return nil
        }
    }
    
    var simpleAnchorsTypes: [SimpleAnchorType] {
        switch self {
        case .simple(let simpleAnchor):
            return [simpleAnchor]
        case .special(let specialAnchor):
            switch specialAnchor {
            case .leftToRight:
                return [.left]
            case .topToBottom:
                return [.top]
            }
        case .center:
            return [.centerX, .centerY]
        case .inner:
            return [.top, .left, .right, .bottom]
        case .sides:
            return [.left, .right]
        case .topAndBottom:
            return [.top, .bottom]
        }
    }
}
