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
    case none
    case loading
    case success
}

struct LoginState {
    var username: String = ""
    var password: String = ""
    var loginRequestState: LoginRequestState = .none
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
        if (self.state.username == "Test" && self.state.password == "Test") {
            self.updateAnimated {
                self.state.usernameValid = true
                self.state.passwordValid = true
            }
        } else {
            self.updateAnimated {
                self.state.usernameValid = false
                self.state.passwordValid = false
            }
        }
    }

    @objc func signup() {
        self.updateAnimated {
            self.state.loginRequestState = .loading
        }

        self.router?.switchRoute(.list)
    }

    @objc func usernameChanged(_ newValue: UITextField) {
        self.updateNoRender {
            self.state.username = newValue.text ?? ""
        }
    }

    @objc func passwordChanged(_ newValue: UITextField) {
        self.updateNoRender {
            self.state.password = newValue.text ?? ""
        }
    }

    override func render(_ state: LoginState) -> ContainerComponent {
        let validLabel: Component? = state.usernameValid ? nil : Label(text: "Invalid Username!")

        return CenterComponent(
            width: 200,
            height: 200,
            component:
                StackComponent(
                    distribution: .fillEqually,
                    backgroundColor: Color(hexString: ""),
                    childComponents: [
                        validLabel,
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
                            axis: .horizontal,
                            distribution: .fillEqually,
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
