//
//  CenterComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/18/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct CenterComponent: Component, ContainerComponent {
    let width: Float
    let height: Float
    let component: Component

    var childComponents: [Component] {
        return [component]
    }
}
