//
//  TextInputRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension TextInput: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let textField = UITextField()
        textField.text = self.text
        textField.placeholder = self.placeholderText
        textField.backgroundColor = UIColor(
            rgba: self.backgroundColor.hexString
        )

        textField.addTarget(
            self.onChangedTarget,
            action: self.onChangedSelector,
            forControlEvents: .EditingChanged
        )

        return .Leaf(self, textField)
    }

    func updateUIKit(
        view: UIView,
        change: Changes,
        newComponent: UIKitRenderable,
        renderTree: UIKitRenderTree) -> UIKitRenderTree
    {
        guard let textField = view as? UITextField else { fatalError() }
        guard let newComponent = newComponent as? TextInput else { fatalError() }

        textField.text = newComponent.text
        textField.placeholder = newComponent.placeholderText
        textField.backgroundColor = UIColor(
            rgba: self.backgroundColor.hexString
        )
        
        return .Leaf(newComponent, textField)
    }

}
