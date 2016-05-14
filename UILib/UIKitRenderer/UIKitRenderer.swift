//
//  UIKitRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

protocol UIKitRenderable {
    func renderUIKit() -> UIView
}

extension NavigationBarComponent: UIKitRenderable {

    func renderUIKit() -> UIView {
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        navigationItem.title = self.title
        navigationBar.pushNavigationItem(navigationItem, animated: false)

        return navigationBar
    }

}

extension StackComponent: UIKitRenderable {

    func renderUIKit() -> UIView {
        let childComponents = self.components.flatMap { $0 as? UIKitRenderable }
        let childViews = childComponents.map { component in
            component.renderUIKit()
        }

        let stackView = UIStackView(arrangedSubviews: childViews)
        stackView.axis = .Vertical
        stackView.backgroundColor = .whiteColor()

        return stackView
    }

}
