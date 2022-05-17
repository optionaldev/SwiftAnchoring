//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct UIKit.CGFloat

// MARK: - Base anchor

public class BaseAnchor: BaseAnchorProtocol {
    public var value: CGFloat
    public var safe: Bool
    public var type: AnchorType
    
    public required init() {
        safe = false
        type = .center
        value = 0
    }
}

// MARK: - Concrete anchors

public final class TargetHorizontalAnchor: BaseAnchor, TargetHorizontalAnchorProtocol {}
public final class HorizontalAnchor: BaseAnchor, SimpleHorizontalAnchorProtocol {}

public final class VerticalAnchor: BaseAnchor, SimpleVerticalAnchorProtocol {}
public final class TargetVerticalAnchor: BaseAnchor, TargetVerticalAnchorProtocol {}

public final class Anchor: BaseAnchor, AnchorProtocol {}
