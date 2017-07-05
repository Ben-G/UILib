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
    var router: Router!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        router = Router(initialRoute: .loginSignup)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = router.rootViewController
        self.window?.makeKeyAndVisible()

        router.rootViewController.view.frame = UIScreen.main.bounds

        return true
    }

}

enum Route {
    case loginSignup
    case list
}

class Router {
    var route: Route

    var userComponent: UserComponentContainer
    var loginComponent: LoginComponentContainer!
    var renderView: RenderView!
    var rootViewController: FullScreenViewController!

    init(initialRoute: Route) {
        self.route = initialRoute

        self.userComponent = UserComponentContainer(state:
                    UserViewState(
                        users: [
                            User("OK"),
                            User("Benji"),
                            User("Another User")
                        ]
                    )
                )

        self.loginComponent = LoginComponentContainer(state: LoginState(), router: self)
        self._applyCurrentRoute()
    }

    func _applyCurrentRoute() {
        switch self.route {
        case .loginSignup:
            self.renderView = RenderView(container: loginComponent)
        case .list:
            self.renderView = RenderView(container: userComponent)
        }

        if self.rootViewController == nil {
            self.rootViewController = FullScreenViewController(view: self.renderView.view)
        } else {
            self.rootViewController.contentView = self.renderView.view
        }
    }

    func switchRoute(_ route: Route) {
        self.route = route
        self._applyCurrentRoute()
    }

}
