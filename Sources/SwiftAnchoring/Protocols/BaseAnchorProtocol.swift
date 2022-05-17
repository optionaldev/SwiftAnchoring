//
// The SwiftAnchoring project.
// Created by optionaldev on 17/05/2022.
// Copyright © 2021 optionaldev. All rights reserved.
//

import typealias UIKit.CGFloat

public protocol BaseAnchorProtocol: CustomStringConvertible {
    
    var value: CGFloat { get set }
    var type: AnchorType { get set }
    
    init()
}

// Why UInt? Because it's the most common and most likely to be used and will prevent unwanted behaviour
// A bit backwards if you're used to constraints being negative, but in many scenarios you setup opposite
// constraints by passing: someValue to one and -someValue to the other

// For the rare cases where a negative value would actually be useful, they will have separate calls //// TODO
public extension BaseAnchorProtocol {
    
    init(type: SimpleAnchorType, value: CGFloat = 0, unsigned: UInt = 0) {
        self.init()
        self.type = .simple(type)
        self.value = unsigned != 0 ? CGFloat(unsigned) : value
    }
    
    init(type: SpecialAnchorType, value: CGFloat = 0, unsigned: UInt = 0) {
        self.init()
        self.type = .special(type)
        self.value = unsigned != 0 ? CGFloat(unsigned) : value
    }
    
    init(type: AnchorType, value: CGFloat = 0, unsigned: UInt = 0) {
        self.init()
        self.type = type
        self.value = unsigned != 0 ? CGFloat(unsigned) : value
    }
    
    var description: String {
        return "Anchor: type = \(type) value = \(value)"
    }
}
