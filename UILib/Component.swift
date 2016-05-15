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

    func applyChanges(change: Changes)
}

extension ContainerComponent {
    func applyChanges(change: Changes) {
//        print(change)
    }
}

extension ContainerComponent {

    var description: String {
        return self.childComponents.description
    }

}

struct Button: Component {
    let title: String
    let target: AnyObject
    let selector: Selector
}

struct BarButton: Component {
    let title: String
    let onTapTarget: AnyObject
    let onTapSelector: Selector

    init(title: String, onTapTarget: AnyObject, onTapSelector: Selector) {
        self.title = title
        self.onTapTarget = onTapTarget
        self.onTapSelector = onTapSelector
    }
}

struct NavigationBarComponent: Component {
    let leftBarButton: BarButton?
    let rightBarButton: BarButton?
    let title: String
}

struct StackComponent: Component, ContainerComponent {
    let childComponents: [Component]
    let backgroundColor: Color
}
