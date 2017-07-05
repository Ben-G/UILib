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
    let distribution: Distribution
    let axis: Axis

    init(
        axis: Axis = .vertical,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        backgroundColor: Color,
        childComponents: [Component?])
    {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.backgroundColor = backgroundColor
        self.childComponents = childComponents.filter { $0 != nil }.map { $0! }
    }

    enum Axis {
        case vertical
        case horizontal
    }

    enum Alignment {
        case fill
        case leading
        case center
        case trailing
    }

    enum Distribution {
        case fill
        case fillEqually
        case fillProportionally
        case equalSpacing
        case equalCentering
    }
}
