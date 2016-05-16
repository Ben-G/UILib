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

            self.lastRenderTree = applyReconcilation(
                lastRenderTree,
                changeSet: reconcilerResults,
                newComponent: component as! UIKitRenderable
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

    // Note: Right now it is not possible to return a new view instance from this method. This
    // new instance would not be inserted into the view hierarchy!
    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree
}

extension UIKitRenderable {
    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {

        return .Leaf(self, view)
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

    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {

        guard let navigationBar = view as? UINavigationBar else { fatalError() }
        guard let newComponent = newComponent as? NavigationBarComponent else { fatalError() }

        navigationBar.popNavigationItemAnimated(false)

        let navigationItem = UINavigationItem()
        navigationItem.title = newComponent.title

        if let leftBarButton = newComponent.leftBarButton {
            navigationItem.leftBarButtonItem = leftBarButton.renderUIKit()
        }

        if let rightBarButton = newComponent.rightBarButton {
            navigationItem.rightBarButtonItem = rightBarButton.renderUIKit()
        }

        navigationBar.pushNavigationItem(navigationItem, animated: false)

        return .Leaf(newComponent, navigationBar)
    }
}

extension BarButton {

    func renderUIKit() -> UIBarButtonItem {

        let barButton = UIBarButtonItem(
            title: self.title,
            style: .Plain,
            target: self.onTapTarget,
            action: self.onTapSelector
        )

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

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree
    ) -> UIKitRenderTree {

        guard let stackView = view as? UIStackView else { fatalError() }
        guard case let .Node(_, _, childTree) = renderTree else { fatalError() }

        var children = childTree

        if case let .Root(changes) = change {

            for change in changes {

                switch change {
                case let .Insert(index, _):
                    let renderTreeEntry = ((newComponent as! ContainerComponent).childComponents[index] as! UIKitRenderable).renderUIKit()
                    stackView.insertArrangedSubview(renderTreeEntry.view, atIndex: index)
                    children.insert(renderTreeEntry, atIndex: index)
                case let .Remove(index):
                    let childView = children[index].view
                    stackView.removeArrangedSubview(childView)
                    childView.removeFromSuperview()
                    children.removeAtIndex(index)
                default:
                    break
                }
            }

        }

        return .Node(newComponent, stackView, children)
    }

}

func applyViewModelUserCell(user: String) -> (cell: UITableViewCell) -> Void {
    return { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
