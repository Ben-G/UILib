//
//  BarButtonComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

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
