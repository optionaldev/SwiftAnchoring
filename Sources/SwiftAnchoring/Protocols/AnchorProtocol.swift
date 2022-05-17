//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//

public protocol AnchorProtocol: SourceHorizontalAnchorProtocol, SourceVerticalAnchorProtocol {}

public extension AnchorProtocol {
    static var center: Self {
        return .init(type: .center)
    }
    
    // Anchors to .top, .bottom, .leading & .trailing
    static var inner: Self {
        return .init(type: .inner)
    }
    
    static func inner(_ constant: UInt) -> Self {
        return .init(type: .inner, unsigned: constant)
    }
}
