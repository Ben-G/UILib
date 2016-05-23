#UILib

UILib brings the concepts of Facebook's React to Swift and UIKit. It allows you to build UIs in declarative way utilizing
a one-way data flow.

⚠️ It is currently a work in progress proof of concept with very limited functionality. ⚠️

#About

Using UILib you create scenes in your app by creating a `ComponentContainer`. A component container stores the state for a specific scene
and provides a `render` function to produce the view for that scene. Whenever the state in a `ComponentContainer` updates, the `render` function is invoked.
The `render` function will produce a component tree for each state update.

UILib will take that component tree and generate the necessary UI components to render it. On subsequent state updates UILib will compare the current container tree to the
new one and update the UIKit representation automatically. This allows developers to write views declaratively without worrying about how they need to be updated.


#Example

Here's an example of a `ComponentContainer` for a login view:

```swift
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
```

#Goals Of This Library

- Develop a proof of concept to see if we can wrap UIKit into a declarative view layer that we can use in production apps
- Make the library as uninvasive as possible: make it use system components; make it easy to use with existing UI components
- Use native UI APIs on the rendering layer to get full functionality of complex UI components, such as table views and collection views

#Technical Details

In UILib each scene is represented by a `ComponentContainer<T>`. The component container stores the specific state for a scene. It's generic over the scenes type.
Each component container has a `render` function. Whenever the state stored in a container changes, the `render` function is called. 

The `render` function is responsible for generating a component tree based on the current state of the container.

There are two types of components in UILib: `Component` and `ContainerComponent`. Components represent simple UI components, such as buttons or text inputs.
Container components represent views that manage a collection of other views, such as table views or stack views.

Each Component has one renderer per supported platform. Currently UILib only supports UIKit. The renderer is responsible for generating a native UI component from the state
described in the component. The renderer is also responsible for performing successive updates on the already existing view.

UILib supports diffing of component trees using the awesome [`Dwifft` library](https://github.com/jflinter/Dwifft). Whenever a state update
results in a new component tree, UILib will diff the old and new component tree and derive the necessary changes.

UILib will reuse all of the views that remained in the same position in the component tree. 

The calculated changes from the diffing algorithm  can either be an `Insert`, `Delete` or an `Update`. `Insert` and `Delete` are handled by `ContainerComponent`s, e.g. `TableView` or `StackComponent`; each of these components knows how to add or remove children and their renderers have custom implementations for these changes as well. E.g. a `TableView` will use the `deleteRowsAtIndexPaths:` method to remove children with the expected animation.

Currently all plain components (buttons, text fields, etc.) will be updated on each render pass; in a future improvement the library will check if a specific view component's state changed or not before updating it.

###Animated State Changes

UILib supports a very naive way of rendering state changes. When mutating the state in a component container the update can be wrapped in a `updateAnimated` block:

```swift
self.updateAnimated {
	self.state.usernameValid = false
	self.state.passwordValid = false
}
```
The resulting changes will then be rendered within a `UIView.animateWithDuration...` block.

###State Changes Without Re-Render

UILib provides another special way to perform updates that works around two-way binding issues. If we want to update the state in response to an update that we received from a UI component (e.g. user entered a new text), then we want to avoid a re-render when we update the state. This can be done as following:

```swift
@objc func usernameChanged(newValue: UITextField) {
    self.updateNoRender {
        self.state.username = newValue.text ?? ""
    }
}
```

#Similar Projects

Check out [Few.swift](https://github.com/joshaber/Few.swift) by Josh Abernathy which has the same goal and is more mature (even though it's experimental as well). One of the major differences is that Few.swift uses CSS layout, just as React does.