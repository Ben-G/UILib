//
//  VerticalMargin.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class VerticalMargin: Component {

    var margin: CGFloat
    var color: Color?

    convenience init(margin: CGFloat) {
        self.init(margin: margin, color: nil)
    }

    init(margin: CGFloat, color: Color?) {
        self.margin = margin
        self.color = color
    }

}
