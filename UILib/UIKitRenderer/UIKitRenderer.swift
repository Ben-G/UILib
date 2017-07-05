//
//  UIKitRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

/// A view that can render a `ContainerComponent`
final class RenderView: Renderer {

    var view = UIView()
    var container: ComponentContainer

    var lastRootComponent: ContainerComponent?
    var lastRenderTree: UIKitRenderTree?

    init(container: ComponentContainer) {
        var container = container

        self.container = container
        container.renderer = self
    }

    func renderComponent(_ component: ContainerComponent, animated: Bool) {
        defer {
            // When leaving this function, store the new component
            // as the `lastRootComponent`.
            self.lastRootComponent = component
        }

        // If we have an existing root component, calculate diffs instead of rendering from scratch
        if let lastRootComponent = self.lastRootComponent, let lastRenderTree = lastRenderTree {
            // Calculate the difference between old and new component tree
            let reconcilerResults = diffChanges(lastRootComponent, newTree: component)

            // Wrap the UIKit updates into a closure
            let updates: () -> UIKitRenderTree = {
                applyReconcilation(
                    lastRenderTree,
                    changeSet: reconcilerResults,
                    newComponent: component as! UIKitRenderable
                )
            }

            // Decide wheter or not to perform the updates animated
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.lastRenderTree = updates()
                }) 
            } else {
                self.lastRenderTree = updates()
            }
        } else {
            // Perform a full render pass
            if let renderTree = (component as? UIKitRenderable)?.renderUIKit() {
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }

                self.lastRenderTree = renderTree

                renderTree.view.frame = self.view.frame
                renderTree.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(renderTree.view)
            }
        }
    }

}


protocol UIKitRenderable {
    func renderUIKit() -> UIKitRenderTree

    // Note: Right now it is not possible to return a new view instance from this method. This
    // new instance would not be inserted into the view hierarchy!
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree
}

extension UIKitRenderable {
    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {

        return .leaf(self, view)
    }
}
