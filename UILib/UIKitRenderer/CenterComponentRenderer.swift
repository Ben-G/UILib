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

        view.frame = CGRect(x: 0, y: 0, width: CGFloat(self.width), height: CGFloat(self.height))
        let renderTree = (self.component as! UIKitRenderable).renderUIKit()
        let subview = renderTree.view
        view.addSubview(subview)

        subview.bounds = view.bounds
        subview.center = view.center
        subview.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin
        ]

        subview.setNeedsLayout()

        view.backgroundColor = .gray

        return .node(self, view, [renderTree])
    }

    func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard case let .node(_, _, childTree) = renderTree else { fatalError() }
        guard let newComponent = newComponent as? CenterComponent else { fatalError() }

        childTree[0].view.bounds = CGRect(x: 0, y: 0, width: CGFloat(newComponent.width), height: CGFloat(newComponent.height))
        childTree[0].view.center = view.center

        return .node(self, view, childTree)
    }

}
