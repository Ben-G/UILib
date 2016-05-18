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

    }

    @objc func signup() {

    }

    override func render(state: LoginState) -> ContainerComponent {



        return StackComponent(
            distribution: .EqualSpacing,
            backgroundColor: Color(hexString: ""),
            childComponents: [
                TextInput(
                    text: state.username,
                    placeholderText: "Username",
                    backgroundColor: state.passwordValid ? .whiteColor() : .redColor()
                ),
                TextInput(
                    text: state.password,
                    placeholderText: "Password",
                    backgroundColor: state.passwordValid ? .whiteColor() : .redColor()
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

    }

}
