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
        axis: Axis = .Vertical,
        alignment: Alignment = .Fill,
        distribution: Distribution = .Fill,
        backgroundColor: Color,
        childComponents: [Component])
    {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.backgroundColor = backgroundColor
        self.childComponents = childComponents
    }

    enum Axis {
        case Vertical
        case Horizontal
    }

    enum Alignment {
        case Fill
        case Leading
        case Center
        case Trailing
    }

    enum Distribution {
        case Fill
        case FillEqually
        case FillProportionally
        case EqualSpacing
        case EqualCentering
    }
}
