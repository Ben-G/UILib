//
//  AppDelegate.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

var userComponent: UserComponentContainer!
var renderView: RenderView<UserViewState>!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        userComponent = UserComponentContainer(state:
            UserViewState(
                abState: .B,
                users: [
                    User("OK"),
                    User("Benji"),
                    User("Another User")
                ]
            )
        )
        
        renderView = RenderView(container: userComponent)

        rootViewController = FullScreenViewController(
            view: renderView.view
        )
        
        rootViewController.view.frame = UIScreen.mainScreen().bounds

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }

}


