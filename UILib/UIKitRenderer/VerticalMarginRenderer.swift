//
//  VerticalMarginRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

final class VerticalMarginRenderer {

    init(verticalMargin: VerticalMargin) {
        self.verticalMargin = verticalMargin
    }

    lazy var view: _VerticalMarginView = { return _VerticalMarginView() }()
    var verticalMargin: VerticalMargin

    func toUIKitView() -> UIView {
        var _size: CGSize {
            return CGSizeMake(0, self.verticalMargin.margin)
        }

        self.view.backgroundColor = .redColor()
        self.view._margin = self.verticalMargin.margin

        return self.view
    }
}

class _VerticalMarginView: UIView {

    var _margin: CGFloat = 0.0
    var _size: CGSize {
        return CGSizeMake(0, self._margin)
    }

    var _color: UIColor = .clearColor() {
        didSet {
            self.backgroundColor = _color
        }
    }

    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func intrinsicContentSize() -> CGSize {
        return _size
    }
    
}
