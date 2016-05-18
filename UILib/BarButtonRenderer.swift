//
//  BarButtonRenderer.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

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
