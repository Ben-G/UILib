//
//  UIKitReconciler.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

enum UIKitRenderTree {
    indirect case Node(UIKitRenderable, UIView, [UIKitRenderTree])
    case Leaf(UIKitRenderable, UIView)

    var view: UIView {
        switch self {
        case let .Node(_, view, _):
            return view
        case let .Leaf(_, view):
            return view
        }
    }

    var renderable: UIKitRenderable {
        switch self {
        case let .Node(renderable, _, _):
            return renderable
        case let .Leaf(renderable, _):
            return renderable
        }
    }
}

enum Changes{
    case Insert(index: Int, identifier: String)
    case Remove(index: Int)
    case Update
    case None
    indirect case Root([Changes])
}

func applyReconcilation(
    renderTree: UIKitRenderTree,
    changeSet: Changes,
    newComponent: UIKitRenderable) -> UIKitRenderTree {

    var newRenderTree: UIKitRenderTree?

    switch (changeSet, renderTree) {
    case let (.Root(changes), .Node(_, _, oldChildTree)):
        // Apply change to root
        newRenderTree = renderTree.renderable.updateUIKit(renderTree.view, change: changeSet, newComponent: newComponent, renderTree: renderTree)

        var newChildTree = oldChildTree

        if case let .Node(renderable, view, childTree) = newRenderTree! {
            newChildTree = childTree

            for (index, change) in changes.enumerate() {
                if case .Update = change {
                    // Only updates should be applied to children directly
                    let component = (newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable
                    let recycledView = childTree[index].view
                    newChildTree[index] = childTree[index].renderable.updateUIKit(recycledView, change: change, newComponent: component, renderTree: renderTree)
                }

                if case .Root = change {
                    let component = (newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable
                    newChildTree[index] = applyReconcilation(childTree[index], changeSet: change, newComponent: component)
                }
            }

            newRenderTree = .Node(renderable, view, newChildTree)
        }
    case let (.Root(changes), .Leaf(renderable, view)):
        // Apply change to root
        newRenderTree = renderTree.renderable.updateUIKit(renderTree.view, change: changeSet, newComponent: newComponent, renderTree: renderTree)
    default:
        break
    }

    return newRenderTree!
}
