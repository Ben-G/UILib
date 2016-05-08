//
//  AppDelegate.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

var userViewModel: UserViewComponent?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let cellTypes = [CellTypeDefinition(
            nibFilename: "UserCell",
            cellIdentifier: "UserCell"
        )]

        let initialState = [
            "OK",
            "Benji",
            "Another User"
        ]

        let renderer = TableViewRenderer(
            cellTypes: cellTypes
        )

        userViewModel = UserViewComponent(renderer: renderer, state: initialState)

        let viewController = FullScreenViewController(view: renderer)
        viewController.view.frame = UIScreen.mainScreen().bounds

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()

        return true
    }

}

final class UserViewComponent: UserViewActionHandlerType {

    let renderer: TableViewRenderer
    private (set) var state: [String]

    init(renderer: TableViewRenderer, state: [String]) {
        self.renderer = renderer
        self.state = state

        renderer.tableViewModel = userView(state, actionHandler: self)
    }

    func deleteUser() {
        self.state.removeLast()
        renderer.tableViewModel = userView(state, actionHandler: self)
    }
}
