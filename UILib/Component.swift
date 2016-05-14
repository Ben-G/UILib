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

struct NavigationBarComponent: Component {
    let leftBarButton: Button?
    let rightBarButton: Button?
    let title: String
}

struct StackComponent: Component {
    let components: [Component]
    let backgroundColor: Color
}
