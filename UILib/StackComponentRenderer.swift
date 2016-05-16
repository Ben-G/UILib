//
//  StackComponentRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension StackComponent: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        var childViews: [UIView]
        var childRenderables: [UIKitRenderTree]

        let childComponents = self.childComponents.flatMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component in
            component.renderUIKit()
        }

        childViews = children.map { $0.view }

        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = .Vertical
        stackView.backgroundColor = .whiteColor()

        return .Node(self, stackView, children)
    }

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {

        guard let stackView = view as? UIStackView else { fatalError() }
        guard case let .Node(_, _, childTree) = renderTree else { fatalError() }

        var children = childTree

        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []

        if case let .Root(changes) = change {

            for change in changes {

                switch change {
                case let .Insert(index, _):
                    let renderTreeEntry = ((newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable).renderUIKit()
                    viewsToInsert.append((index, renderTreeEntry.view, renderTreeEntry))
                case let .Remove(index):
                    let childView = children[index].view
                    viewsToRemove.append((index, childView))
                default:
                    break
                }
            }
            
        }

        var indexOffset = 0

        for insert in viewsToInsert {
            stackView.insertArrangedSubview(insert.view, atIndex: insert.index)
            children.insert(insert.renderTree, atIndex: insert.index)

            indexOffset += 1
        }

        for remove in viewsToRemove {
            stackView.removeArrangedSubview(remove.view)
            remove.view.removeFromSuperview()
            children.removeAtIndex(remove.index + indexOffset)
        }

        return .Node(newComponent, stackView, children)
    }
    
}
