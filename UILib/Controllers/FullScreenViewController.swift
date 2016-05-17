//
//  FullScreenViewController.swift
//  UILib
//
//  Created by Benji Encz on 5/4/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    let contentView: UIView

    init(view: UIView) {
        self.contentView = view
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.addSubview(self.contentView)

//        self.view.translatesAutoresizingMaskIntoConstraints = false
//
//        let equalWidthConstraint = NSLayoutConstraint(
//            item: self.contentView,
//            attribute: .Width,
//            relatedBy: .Equal,
//            toItem: self.view,
//            attribute: .Width,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let equalHeightConstraint = NSLayoutConstraint(
//            item: self.contentView,
//            attribute: .Height,
//            relatedBy: .Equal,
//            toItem: self.view,
//            attribute: .Height,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let equalX = NSLayoutConstraint(
//            item: self.contentView,
//            attribute: .CenterX,
//            relatedBy: .Equal,
//            toItem: self.view,
//            attribute: .CenterX,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let equalY = NSLayoutConstraint(
//            item: self.contentView,
//            attribute: .CenterY,
//            relatedBy: .Equal,
//            toItem: self.view,
//            attribute: .CenterY,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        self.contentView.addConstraints([
//            equalWidthConstraint
////            equalHeightConstraint,
////            equalX,
////            equalY
//            ]
////        )

        self.contentView.addConstraint(NSLayoutConstraint(
            item: self.contentView,
            attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 200)
        )
    }
}
