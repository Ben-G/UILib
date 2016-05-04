//
//  AppDelegate.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let cellTypes = [CellTypeDefinition(
            nibFilename: "UserCell",
            cellIdentifier: "UserCell"
        )]


        let userViewModel = userView([
            "OK",
            "Benji",
            "Another User"
        ])

        let renderer = TableViewRenderer(
            tableViewModel: userViewModel,
            cellTypes: cellTypes
        )

        let viewController = FullScreenViewController(view: renderer)
        viewController.view.frame = UIScreen.mainScreen().bounds

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()

        return true
    }

}
