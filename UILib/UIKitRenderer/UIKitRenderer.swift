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

    init(container: BaseComponentContainer<T>) {
        self.container = container
        container.renderer = self
    }

    func renderComponent(component: Component) {
        if let view = (component as? UIKitRenderable)?.renderUIKit() {
            self.view.subviews.forEach {
                $0.removeFromSuperview()
            }

            view.frame = self.view.frame
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.view.addSubview(view)
        }
    }

}

protocol UIKitRenderable {
    func renderUIKit() -> UIView
}

extension NavigationBarComponent: UIKitRenderable {

    func renderUIKit() -> UIView {
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

        return navigationBar
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

    func renderUIKit() -> UIView {
        let childComponents = self.childComponents.flatMap { $0 as? UIKitRenderable }
        let childViews = childComponents.map { component in
            component.renderUIKit()
        }

        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = .Vertical
        stackView.backgroundColor = .whiteColor()

        return stackView
    }

}

func applyViewModelUserCell(user: String) -> (cell: UITableViewCell) -> Void {
    return { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
