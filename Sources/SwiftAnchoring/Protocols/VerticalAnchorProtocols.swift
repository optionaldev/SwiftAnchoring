//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//


// Useful both as a source & as a target

public protocol TargetVerticalAnchorProtocol: BaseAnchorProtocol {}

public extension TargetVerticalAnchorProtocol {
    
    static var top: Self {
        return .init(type: .top)
    }
    
    static var bottom: Self {
        return .init(type: .bottom)
    }
    
    static var centerY: Self {
        return .init(type: .centerY)
    }
}

// Useful only as a source. Includes constants. Prevents calls such as '.anchor(.top(5), with: view, .top(5))'

public protocol SimpleVerticalAnchorProtocol: TargetVerticalAnchorProtocol {}

public extension SimpleVerticalAnchorProtocol {
    
    static func mid(_ constant: UInt) -> Self {
        return .init(type: .top, unsigned: constant)
    }
    
    static func top(_ constant: UInt) -> Self {
        return .init(type: .top, unsigned: constant)
    }
    
    static func bottom(_ constant: UInt) -> Self {
        return .init(type: .bottom, unsigned: constant)
    }
}

// Useful when only source is specifyable, since calls such as 'anchor(.topToBottom, with: view, .topToBottom)' doesn't make sense

public protocol SourceVerticalAnchorProtocol: SimpleVerticalAnchorProtocol {}

public extension SourceVerticalAnchorProtocol {
    
    static var topAndBottom: Self {
        return .init(type: .topAndBottom)
    }
    
    static func topAndBottom(_ constant: UInt) -> Self {
        return .init(type: .topAndBottom, unsigned: constant)
    }
    
    static var topToBottom: Self {
        return .init(type: .topToBottom)
    }
    
    static func topToBottom(_ constant: UInt) -> Self {
        return .init(type: .topToBottom, unsigned: constant)
    }
}
