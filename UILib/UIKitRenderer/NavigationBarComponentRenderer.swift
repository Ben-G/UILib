//
//  NavigationBarComponentRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

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
