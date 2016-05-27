//
//  LabelRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/26/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension Label: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let label = UILabel()
        label.text = self.text

        return .Leaf(self, label)
    }

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard let view = view as? UILabel else { fatalError() }
        guard let newComponent = newComponent as? Label else { fatalError() }

        view.text = newComponent.text

        return .Leaf(newComponent, view)
    }

}
