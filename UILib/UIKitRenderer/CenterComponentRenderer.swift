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

        subview.bounds = view.bounds
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
        guard let newComponent = newComponent as? CenterComponent else { fatalError() }

        childTree[0].view.bounds = CGRectMake(0, 0, CGFloat(newComponent.width), CGFloat(newComponent.height))
        childTree[0].view.center = view.center

        return .Node(self, view, childTree)
    }

}
