//
//  VerticalMargin.swift
//  UILib
//
//  Created by Benji Encz on 5/12/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

class VerticalMargin: Component {

    var margin: Float
    var color: Color?

    convenience init(margin: Float) {
        self.init(margin: margin, color: nil)
    }

    init(margin: Float, color: Color?) {
        self.margin = margin
        self.color = color
    }

}
