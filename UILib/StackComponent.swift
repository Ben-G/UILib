//
//  StackComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct StackComponent: Component, ContainerComponent {
    let childComponents: [Component]
    let backgroundColor: Color
    let alignment: Alignment

    init(alignment: Alignment = .Fill, backgroundColor: Color, childComponents: [Component]) {
        self.alignment = alignment
        self.backgroundColor = backgroundColor
        self.childComponents = childComponents
    }

    enum Alignment {
        case Fill
        case Leading
        case Center
        case Trailing
    }
}
