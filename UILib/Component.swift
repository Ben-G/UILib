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

protocol Component { }

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

struct StackComponent: Component {
    let components: [Component]
    let backgroundColor: Color
}
