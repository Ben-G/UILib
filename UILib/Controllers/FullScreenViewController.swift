//
//  FullScreenViewController.swift
//  UILib
//
//  Created by Benji Encz on 5/4/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    var contentView: UIView {
        didSet {
            oldValue.removeFromSuperview()

            self.view.addSubview(self.contentView)
            self.contentView.frame = self.view.bounds
            self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    init(view: UIView) {
        self.contentView = view

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.contentView)

        self.contentView.frame = self.view.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
