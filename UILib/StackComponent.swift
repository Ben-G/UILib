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
}
