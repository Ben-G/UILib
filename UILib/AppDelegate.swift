//
//  AppDelegate.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

//var userViewModel: UserViewComponent?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let rootComponent = viewForStateA(self, selector: #selector(edit))

        rootViewController = FullScreenViewController(
            view: rootComponent.renderUIKit()
        )
        
        rootViewController.view.frame = UIScreen.mainScreen().bounds

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    @objc func edit() {
        self.rootViewController.view = viewForStateB().renderUIKit()
    }

}


