//
//  VerticalMarginRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit


extension VerticalMargin: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let view = _VerticalMarginView()

        view.backgroundColor = .red
        view._margin = CGFloat(self.margin)

        return .leaf(self, view)
    }

}

class _VerticalMarginView: UIView {

    var _margin: CGFloat = 0.0
    var _size: CGSize {
        return CGSize(width: 0, height: self._margin)
    }

    var _color: UIColor = .clear {
        didSet {
            self.backgroundColor = _color
        }
    }

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize : CGSize {
        return _size
    }
    
}
