//
//  LoginView.swift
//  UILib
//
//  Created by Benji Encz on 5/17/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

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

    override init(state: LoginState) {
        super.init(state: state)
    }

    @objc func login() {
        self.state.usernameValid = false
        self.state.passwordValid = false
    }

    @objc func signup() {

    }

    override func render(state: LoginState) -> ContainerComponent {

        return CenterComponent(
            width: 200,
            height: 200,
            component:
                StackComponent(
                    distribution: .FillEqually,
                    backgroundColor: Color(hexString: ""),
                    childComponents: [
                        TextInput(
                            text: state.username,
                            placeholderText: "Username",
                            backgroundColor: state.usernameValid
                                ? Color(hexString: "#FFFFFF") : Color(hexString: "#FF0000")
                        ),
                        TextInput(
                            text: state.password,
                            placeholderText: "Password",
                            backgroundColor: state.usernameValid
                                ? Color(hexString: "#FFFFFF") : Color(hexString: "#FF0000")
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
