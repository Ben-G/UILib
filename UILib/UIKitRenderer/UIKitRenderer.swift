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

    func renderComponent(component: ContainerComponent) {
        defer {
            self.lastRootComponent = component
        }

        if let lastRootComponent = self.lastRootComponent, lastRenderTree = lastRenderTree {
            // Reconciled rendering
            let reconcilerResults = reconcile(lastRootComponent, newTree: component)

            applyReconcilation(
                lastRenderTree,
                changeSet: reconcilerResults,
                newComponent: component
            )
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
    newComponent: Component) {

    switch changeSet {
    case let .Root(changes):
        for (index, change) in changes.enumerate() {
            switch renderTree {
            case let .Node(renderable, _, childrenRenderTree):
                let childComponents = (newComponent as! ContainerComponent).childComponents
                applyReconcilation(
                    childrenRenderTree[index],
                    changeSet: change,
                    newComponent: childComponents[index]
                )
            case let .Leaf(renderable, view):
                // hack wrapping in root here; until I've figured out mistake in recursion
                renderable.updateUIKit(view, change: .Root(changes), newComponent: newComponent)
            }
        }
    case .Insert, .Remove, .Update, .None:
        break
    }
}

func reconcile(oldTree: ContainerComponent, newTree: ContainerComponent) -> Changes {
    var changes: [Changes] = []

    for component in oldTree.childComponents {
        if component is ContainerComponent {
            // and start out with no changes for container components
            changes.append(.None)
        } else {
            // start out with the assumption that we need to update every regular component
            changes.append(.Update)
        }
    }

    let diff = oldTree.childComponents.map{ $0.componentIdentifier }
        .diff(newTree.childComponents.map { $0.componentIdentifier })

    diff.results.forEach { diffStep in
        switch diffStep {
        case let .Insert(index, identifier):
            changes.append(.Insert(index: index, identifier: identifier))
        case let .Delete(index, _):
            changes[index] = .Remove(index: index)
        }
    }

    for (index, component) in oldTree.childComponents.enumerate() {
        guard case .None = changes[index] else { continue }

        if let container = component as? ContainerComponent {
            // recursively reconcile; force cast is OK here for now since we know component is of identical type 
            // since that was checked in the diffing step
            changes[index] = reconcile(
                container,
                newTree: newTree.childComponents[index] as! ContainerComponent
            )
        }
    }

    return .Root(changes)
}

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

protocol UIKitRenderable {
    func renderUIKit() -> UIKitRenderTree
    func updateUIKit(view: UIView, change: Changes, newComponent: Component) -> UIKitRenderTree
}

extension UIKitRenderable {
    func updateUIKit(view: UIView, change: Changes, newComponent: Component) -> UIKitRenderTree {
        return self.renderUIKit()
    }
}

extension NavigationBarComponent: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        navigationItem.title = self.title

        if let leftBarButton = self.leftBarButton {
            navigationItem.leftBarButtonItem = leftBarButton.renderUIKit()
        }

        if let rightBarButton = self.rightBarButton {
            navigationItem.rightBarButtonItem = rightBarButton.renderUIKit()
        }

        navigationBar.pushNavigationItem(navigationItem, animated: false)

        return .Leaf(self, navigationBar)
    }

}

extension BarButton {

    func renderUIKit() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .Edit,
            target: self.onTapTarget,
            action: self.onTapSelector
        )

        barButton.title = self.title

        return barButton
    }

}

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

}

func applyViewModelUserCell(user: String) -> (cell: UITableViewCell) -> Void {
    return { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
