//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//


public protocol DimensionalAnchorProtocol: BaseAnchorProtocol {}

public extension DimensionalAnchorProtocol {
    static var equalWidth: Self {
        return .init(type: .width)
    }
    
    static var equalHeight: Self {
        return .init(type: .height)
    }
    
    static func width(_ constant: UInt) -> Self {
        return .init(type: .width, unsigned: constant)
    }
    
    static func height(_ constant: UInt) -> Self {
        return .init(type: .height, unsigned: constant)
    }
}
