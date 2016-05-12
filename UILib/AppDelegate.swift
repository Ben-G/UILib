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
    var rootViewController: UIViewController!


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

        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        navigationItem.title = "Test Title"
        navigationBar.pushNavigationItem(navigationItem, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(edit))

        let placeholder = VerticalMargin(margin: 20.0, color: .lightGrayColor())

        let stackView = UIStackView(arrangedSubviews: [
            placeholder,
            navigationBar,
            renderer
        ])

        stackView.axis = .Vertical
        stackView.backgroundColor = UIColor.whiteColor()

        rootViewController = FullScreenViewController(view: stackView)
        rootViewController.view.frame = UIScreen.mainScreen().bounds

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    @objc func edit() {
        self.rootViewController.view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
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

    func deleteUser(indexPath: NSIndexPath) {
        self.state.removeAtIndex(indexPath.row)

        renderer.newViewModelWithChangeset(
            userView(state, actionHandler: self),
            changeSet: .Delete(indexPath)
        )
    }
}
