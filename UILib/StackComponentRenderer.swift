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

        let childComponents = self.childComponents.flatMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component in
            component.renderUIKit()
        }

        childViews = children.map { $0.view }

        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = convertAxis(self.axis)
        stackView.backgroundColor = .whiteColor()
        stackView.alignment = convertAlignment(self.alignment)

        return .Node(self, stackView, children)
    }

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {

        guard let newComponent = newComponent as? StackComponent else { fatalError() }

        guard let stackView = view as? UIStackView else { fatalError() }
        stackView.axis = convertAxis(newComponent.axis)
        stackView.backgroundColor = .whiteColor()

        let newAlignment = convertAlignment(newComponent.alignment)

        if newAlignment != stackView.alignment {
            stackView.alignment = newAlignment
        }

        guard case let .Node(_, _, childTree) = renderTree else { fatalError() }

        var children = childTree

        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []

        if case let .Root(changes) = change {

            for change in changes {

                switch change {
                case let .Insert(index, _):
                    let renderTreeEntry = (newComponent.childComponents[index] as! UIKitRenderable).renderUIKit()
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

            indexOffset -= 1
        }

        return .Node(newComponent, stackView, children)
    }
    
}


private func convertAlignment(alignment: StackComponent.Alignment) -> UIStackViewAlignment {
    switch alignment {
    case .Center:
        return UIStackViewAlignment.Center
    case .Fill:
        return UIStackViewAlignment.Fill
    case .Leading:
        return UIStackViewAlignment.Leading
    case .Trailing:
        return UIStackViewAlignment.Trailing
    }
}

private func convertDistribution(distribution: StackComponent.Distribution) -> UIStackViewDistribution {
    switch distribution {
    case .Fill:
        return UIStackViewDistribution.Fill
    case .FillEqually:
        return UIStackViewDistribution.FillEqually
    case .FillProportionally:
        return UIStackViewDistribution.FillProportionally
    case .EqualSpacing:
        return UIStackViewDistribution.EqualSpacing
    case .EqualCentering:
        return UIStackViewDistribution.EqualCentering
    }
}

private func convertAxis(axis: StackComponent.Axis) -> UILayoutConstraintAxis {
    switch axis {
    case .Horizontal:
        return UILayoutConstraintAxis.Horizontal
    case .Vertical:
        return UILayoutConstraintAxis.Vertical
    }
}
