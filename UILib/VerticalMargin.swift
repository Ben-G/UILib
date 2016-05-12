//
//  VerticalMargin.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class VerticalMargin: UIView {

    var _margin: CGFloat
    var _size: CGSize {
        return CGSizeMake(0, self._margin)

    }

    convenience init(margin: CGFloat) {
        self.init(margin: margin, color: .clearColor())
    }

    init(margin: CGFloat, color: UIColor) {
        self._margin = margin

        super.init(frame: CGRectZero)

        self.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func intrinsicContentSize() -> CGSize {
        return _size
    }

}