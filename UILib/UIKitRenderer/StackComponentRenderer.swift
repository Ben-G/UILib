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
        stackView.backgroundColor = .white
        stackView.alignment = convertAlignment(self.alignment)
        stackView.distribution = convertDistribution(self.distribution)

        return .node(self, stackView, children)
    }

    func updateUIKit(
        _ view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
        ) -> UIKitRenderTree {

        guard let newComponent = newComponent as? StackComponent else { fatalError() }

        guard let stackView = view as? UIStackView else { fatalError() }
        stackView.axis = convertAxis(newComponent.axis)
        stackView.backgroundColor = .white

        let newAlignment = convertAlignment(newComponent.alignment)

        if newAlignment != stackView.alignment {
            stackView.alignment = newAlignment
        }

        stackView.distribution = convertDistribution(newComponent.distribution)

        guard case let .node(_, _, childTree) = renderTree else { fatalError() }

        var children = childTree

        var viewsToInsert: [(index: Int, view: UIView, renderTree: UIKitRenderTree)] = []
        var viewsToRemove: [(index: Int, view: UIView)] = []

        if case let .root(changes) = change {

            for change in changes {

                switch change {
                case let .insert(index, _):
                    let renderTreeEntry = (newComponent.childComponents[index] as! UIKitRenderable).renderUIKit()
                    viewsToInsert.append((index, renderTreeEntry.view, renderTreeEntry))
                case let .remove(index):
                    let childView = children[index].view
                    viewsToRemove.append((index, childView))
                default:
                    break
                }
            }
            
        }

        var indexOffset = 0

        for insert in viewsToInsert {
            stackView.insertArrangedSubview(insert.view, at: insert.index)
            children.insert(insert.renderTree, at: insert.index)

            indexOffset += 1
        }

        for remove in viewsToRemove {
            stackView.removeArrangedSubview(remove.view)
            remove.view.removeFromSuperview()
            children.remove(at: remove.index + indexOffset)

            indexOffset -= 1
        }

        return .node(newComponent, stackView, children)
    }
    
}


private func convertAlignment(_ alignment: StackComponent.Alignment) -> UIStackViewAlignment {
    switch alignment {
    case .center:
        return UIStackViewAlignment.center
    case .fill:
        return UIStackViewAlignment.fill
    case .leading:
        return UIStackViewAlignment.leading
    case .trailing:
        return UIStackViewAlignment.trailing
    }
}

private func convertDistribution(_ distribution: StackComponent.Distribution) -> UIStackViewDistribution {
    switch distribution {
    case .fill:
        return UIStackViewDistribution.fill
    case .fillEqually:
        return UIStackViewDistribution.fillEqually
    case .fillProportionally:
        return UIStackViewDistribution.fillProportionally
    case .equalSpacing:
        return UIStackViewDistribution.equalSpacing
    case .equalCentering:
        return UIStackViewDistribution.equalCentering
    }
}

private func convertAxis(_ axis: StackComponent.Axis) -> UILayoutConstraintAxis {
    switch axis {
    case .horizontal:
        return UILayoutConstraintAxis.horizontal
    case .vertical:
        return UILayoutConstraintAxis.vertical
    }
}
