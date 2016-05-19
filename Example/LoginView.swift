//
//  LoginView.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation
import UIKit

enum LoginRequestState {
    case None
    case Loading
    case Success
}

struct LoginState {
    var username: String = ""
    var password: String = ""
    var loginRequestState: LoginRequestState = .None
    var usernameValid: Bool = true
    var passwordValid: Bool = true

    init() {}
}

class LoginComponentContainer: BaseComponentContainer<LoginState> {

    weak var router: Router?

    init(state: LoginState, router: Router) {
        self.router = router

        super.init(state: state)
    }

    @objc func login() {
        self.updateAnimated {
            self.state.usernameValid = false
            self.state.passwordValid = false
        }
    }

    @objc func signup() {
        self.updateAnimated {
            self.state.loginRequestState = .Loading
        }

        self.router?.switchRoute(.List)
    }

    @objc func usernameChanged(newValue: UITextField) {
        self.updateNoRender {
            self.state.username = newValue.text ?? ""
        }
    }

    @objc func passwordChanged(newValue: UITextField) {
        self.updateNoRender {
            self.state.password = newValue.text ?? ""
        }
    }

    override func render(state: LoginState) -> ContainerComponent {
        let (width, height) = { () -> (Float, Float) in
            switch state.loginRequestState {
            case .Loading:
                return (0.0, 0.0)
            default:
                return (200.0, 200.0)
            }
        }()

        return CenterComponent(
            width: width,
            height: height,
            component:
                StackComponent(
                    distribution: .FillEqually,
                    backgroundColor: Color(hexString: ""),
                    childComponents: [
                        TextInput(
                            text: state.username,
                            placeholderText: "Username",
                            backgroundColor: state.usernameValid
                                ? Color(hexString: "#FFFFFF") : Color(hexString: "#FF0000"),
                            onChangedTarget: self,
                            onChangedSelector: #selector(usernameChanged)
                        ),
                        TextInput(
                            text: state.password,
                            placeholderText: "Password",
                            backgroundColor: state.usernameValid
                                ? Color(hexString: "#FFFFFF") : Color(hexString: "#FF0000"),
                            onChangedTarget: self,
                            onChangedSelector: #selector(passwordChanged)
                        ),
                        StackComponent(
                            distribution: .FillEqually,
                            axis: .Horizontal,
                            backgroundColor: Color(hexString: ""),
                            childComponents: [
                                Button(
                                    title: "Login",
                                    target: self,
                                    selector: #selector(login)
                                ),
                                Button(
                                    title: "Signup",
                                    target: self,
                                    selector: #selector(signup)
                                )
                            ]
                        )
                    ]
                )
        )
    }

}
