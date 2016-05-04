//
//  FullScreenViewController.swift
//  UILib
//
//  Created by Benji Encz on 5/4/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    init(view: UIView) {
        super.init(nibName: nil, bundle: nil)

        view.frame = self.view.frame
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        self.view.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
