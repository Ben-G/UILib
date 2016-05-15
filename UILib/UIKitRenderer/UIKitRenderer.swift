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
            print(reconcilerResults)
            applyReconcilation(lastRenderTree, changeSet: reconcilerResults)
        } else {
            // Full render pass
            if let view = (component as? UIKitRenderable)?.renderUIKit() {
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }

                self.lastRenderTree = view.1

                view.0.frame = self.view.frame
                view.0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                self.view.addSubview(view.0)
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

func applyReconcilation(renderTree: UIKitRenderTree, changeSet: Changes) {

    switch changeSet {
    case let .Root(changes):
        for (index, change) in changes.enumerate() {
            switch renderTree {
            case let .Node(renderable, childrenRenderTree):
                print("apply changes to \(renderable)")
                applyReconcilation(childrenRenderTree[index], changeSet: change)
            case let .Leaf(renderable):
                print("applying changes now to \(renderable)!")
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
            changes[index] = .Insert(index: index, identifier: identifier)
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
    indirect case Node(UIKitRenderable, [UIKitRenderTree])
    case Leaf(UIKitRenderable)
}

protocol UIKitRenderable {
    func renderUIKit() -> (UIView, UIKitRenderTree)
}

extension NavigationBarComponent: UIKitRenderable {

    func renderUIKit() -> (UIView, UIKitRenderTree) {
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

        return (navigationBar, .Leaf(self))
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

    func renderUIKit() -> (UIView, UIKitRenderTree) {
        var childViews: [UIView]
        var childRenderables: [UIKitRenderTree]

        let childComponents = self.childComponents.flatMap { $0 as? UIKitRenderable }
        let children = childComponents.map { component in
            component.renderUIKit()
        }


        childViews = children.map { $0.0 }
        childRenderables = children.map { $0.1 }

        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = .Vertical
        stackView.backgroundColor = .whiteColor()

        return (stackView, .Node(self, childRenderables))
    }

}

func applyViewModelUserCell(user: String) -> (cell: UITableViewCell) -> Void {
    return { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
