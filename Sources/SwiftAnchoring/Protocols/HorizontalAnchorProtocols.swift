//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//


// Useful both as a source & as a target

public protocol TargetHorizontalAnchorProtocol: BaseAnchorProtocol {}

public extension TargetHorizontalAnchorProtocol {
    
    static var left: Self {
        return .init(type: .left)
    }
    
    static var right: Self {
        return .init(type: .right)
    }
    
    static var centerX: Self {
        return .init(type: .centerX)
    }
}

// Useful only as a source. Includes constants. Prevents calls such as '.anchor(.left(5), with: view, .left(5))'

public protocol SimpleHorizontalAnchorProtocol: TargetHorizontalAnchorProtocol {}

public extension SimpleHorizontalAnchorProtocol {
    
    static func left(_ constant: UInt) -> Self {
        return .init(type: .left, unsigned: constant)
    }
    
    static func right(_ constant: UInt) -> Self {
        return .init(type: .right, unsigned: constant)
    }
}

// Useful when only source is specifyable, since calls such as 'anchor(.leftToRight, with: view, .leftToRight)' doesn't make sense

public protocol SourceHorizontalAnchorProtocol: SimpleHorizontalAnchorProtocol {}

public extension SourceHorizontalAnchorProtocol {
    
    static var leftToRight: Self {
        return .init(type: .leftToRight)
    }
    
    static var sides: Self {
        return .init(type: .sides)
    }
    
    static func sides(_ constant: UInt) -> Self {
        return .init(type: .sides, unsigned: constant)
    }
    
    static func leftToRight(_ constant: UInt) -> Self {
        return .init(type: .leftToRight, unsigned: constant)
    }
}
