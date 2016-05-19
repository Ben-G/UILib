//
//  UIKitRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

final class RenderView<T>: Renderer {

    var view = UIView()
    var container: BaseComponentContainer<T>

    var lastRootComponent: ContainerComponent?
    var lastRenderTree: UIKitRenderTree?

    init(container: BaseComponentContainer<T>) {
        self.container = container
        container.renderer = self
    }

    func renderComponent(component: ContainerComponent, animated: Bool) {
        defer {
            self.lastRootComponent = component
        }

        if let lastRootComponent = self.lastRootComponent, lastRenderTree = lastRenderTree {
            // Reconciled rendering
            let reconcilerResults = diffChanges(lastRootComponent, newTree: component)

            let updates: () -> UIKitRenderTree = {
                applyReconcilation(
                    lastRenderTree,
                    changeSet: reconcilerResults,
                    newComponent: component as! UIKitRenderable
                )
            }
            if animated {
                UIView.animateWithDuration(0.3) {
                    self.lastRenderTree = updates()
                }
            } else {
                self.lastRenderTree = updates()
            }
        } else {
            // Full render pass
            if let renderTree = (component as? UIKitRenderable)?.renderUIKit() {
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }

                self.lastRenderTree = renderTree

                renderTree.view.frame = self.view.frame
                renderTree.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                self.view.addSubview(renderTree.view)
            }
        }
    }

}


protocol UIKitRenderable {
    func renderUIKit() -> UIKitRenderTree

    // Note: Right now it is not possible to return a new view instance from this method. This
    // new instance would not be inserted into the view hierarchy!
    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree
}

extension UIKitRenderable {
    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {

        return .Leaf(self, view)
    }
}
