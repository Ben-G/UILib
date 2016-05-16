//
//  Component.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct Color {
    let hexString: String
}

public protocol Component {
    var componentIdentifier: String { get }
}

extension Component {
    var componentIdentifier: String { return String(self.dynamicType) }
}

public func == (lhs: Component, rhs: Component) -> Bool {
    return true
}

protocol ContainerComponent: Component {
    var childComponents: [Component] { get }
}
