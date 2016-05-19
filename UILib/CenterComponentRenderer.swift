//
//  CenterComponentRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/18/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension CenterComponent: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let view = UIView()

        view.frame = CGRectMake(0, 0, CGFloat(self.width), CGFloat(self.height))
        let renderTree = (self.component as! UIKitRenderable).renderUIKit()
        let subview = renderTree.view
        view.addSubview(subview)

        subview.frame = view.bounds
        subview.center = view.center
        subview.autoresizingMask = [
            .FlexibleTopMargin,
            .FlexibleLeftMargin,
            .FlexibleRightMargin,
            .FlexibleBottomMargin
        ]

        subview.setNeedsLayout()

        view.backgroundColor = .grayColor()

        return .Node(self, view, [renderTree])
    }

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard case let .Node(_, _, childTree) = renderTree else { fatalError() }

        return .Node(self, view, childTree)
    }

}
