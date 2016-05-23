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

/**
 Type for a simple component without child components, such as a Button
 or a text field.
*/
public protocol Component {
    var componentIdentifier: String { get }
}

extension Component {
    var componentIdentifier: String { return String(self.dynamicType) }
}

public func == (lhs: Component, rhs: Component) -> Bool {
    return true
}

/**
 Type for a component that manages subcomponents, such as a Table View or
 Stack Component.
*/
protocol ContainerComponent: Component {
    var childComponents: [Component] { get }
}
