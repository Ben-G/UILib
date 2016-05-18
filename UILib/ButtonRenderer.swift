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

        let button = UIButton(type: .Custom)
        button.setTitle(self.title, forState: .Normal)
        button.addTarget(self.target, action: self.selector, forControlEvents: .TouchUpInside)
        button.setTitleColor(.blueColor(), forState: .Normal)

        return .Leaf(self, button)
    }
    
}
