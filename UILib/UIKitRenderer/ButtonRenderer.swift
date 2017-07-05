//
//  ButtonRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension Button: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {

        let button = UIButton(type: .custom)
        button.setTitle(self.title, for: UIControlState())
        button.addTarget(self.target, action: self.selector, for: .touchUpInside)
        button.setTitleColor(.blue, for: UIControlState())

        return .leaf(self, button)
    }
    
}
