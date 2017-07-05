//
//  UIKitReconciler.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

/// Describes the current tree of rendered components. Holds onto the cached UIViews and their
/// respective components.
enum UIKitRenderTree {
    indirect case node(UIKitRenderable, UIView, [UIKitRenderTree])
    case leaf(UIKitRenderable, UIView)

    var view: UIView {
        switch self {
        case let .node(_, view, _):
            return view
        case let .leaf(_, view):
            return view
        }
    }

    var renderable: UIKitRenderable {
        switch self {
        case let .node(renderable, _, _):
            return renderable
        case let .leaf(renderable, _):
            return renderable
        }
    }
}

/// Describes changes dervided from diffing two component trees.
enum Changes{
    /// Describes an insertion of a new component
    case insert(index: Int, identifier: String)
    /// Describes the removal of an existing component
    case remove(index: Int)
    /// Describes the update of a simple component (not container component)
    case update
    /// Describes that no changes occured
    case none
    /// Describes the changes that occurred to children of a container component
    // TODO: currently we can't describe changes to the conainer component itself.
    indirect case root([Changes])
}

/// Applies the changes derived from diffing to an existing render tree.
func applyReconcilation(
    _ renderTree: UIKitRenderTree,
    changeSet: Changes,
    newComponent: UIKitRenderable) -> UIKitRenderTree {

    var newRenderTree: UIKitRenderTree?

    switch (changeSet, renderTree) {
    // When we find a root change on a node, we update the node itself and all of its children.
    case let (.root(changes), .node(_, _, oldChildTree)):
        // When we find a root change on a node of the render tree, call it's update `UIKit` method
        // by passing in the change. Store the result as the `newRenderTree`.
        newRenderTree = renderTree.renderable.updateUIKit(
            // Pass the cached view from the old render tree
            renderTree.view,
            // Pass the root change we just found
            change: changeSet,
            // Pass in the new component which will be used for updates
            newComponent: newComponent,
            // pass in the entire cached render tree
            renderTree: renderTree
        )

        // Make a mutable copy of the old child tree to generate the new child tree.
        // We got this child tree from the current node of the cached renter tree.
        var newChildTree = oldChildTree

        // If the root of the new render tree is a node apply changes from the `.Root` change set to
        // its children.
        if case let .node(renderable, view, childTree) = newRenderTree! {
            // The `childTree` of the `newRenderTree` is going to be used as base of our new child tree
            newChildTree = childTree

            var removedIndexes: [Int] = []
            var insertedIndexes: [Int] = []

            for (index, change) in changes.enumerated() {
                if case .remove = change {
                    removedIndexes.append(index)
                    continue
                }

                if case .insert = change {
                    insertedIndexes.append(index)
                    continue
                }

                // Calculate mapping between index in new and old tree by counting insertions and
                // deletions that affect the current index
                let newComponentOffset: Int = {
                    let insertOffsets = insertedIndexes.filter { $0 <= index }.count
                    let removeOffsets = removedIndexes.filter { $0 < index }.count

                    return insertOffsets - removeOffsets
                }()

                let index = index + newComponentOffset

                if case .update = change {
                    // Update each child view by pasing in the cached view, the change, the new component and 
                    // the cached render tree.
                    let component = (newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable
                    let recycledView = childTree[index].view

                    newChildTree[index] = childTree[index].renderable.updateUIKit(
                        recycledView,
                        change: change,
                        newComponent: component,
                        renderTree: renderTree
                    )
                }

                if case .root = change {
                    // For root changes, call `applyReconciliation` recursively with the according child component
                    let component = (newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable
                    newChildTree[index] = applyReconcilation(childTree[index], changeSet: change, newComponent: component)
                }
            }

            // Update the `newRenderTree` with the changes we got from updating all children
            newRenderTree = .node(renderable, view, newChildTree)
        }
    // When we find a root change on a leaf, we only need to update the leaf itself.
    case (.root, .leaf):
        newRenderTree = renderTree.renderable.updateUIKit(
            renderTree.view,
            change: changeSet,
            newComponent: newComponent,
            renderTree: renderTree
        )
    default:
        break
    }

    return newRenderTree!
}
