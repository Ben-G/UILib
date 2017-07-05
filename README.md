# UILib

UILib brings the concepts of Facebook's React to Swift and UIKit. It allows you to build UIs in declarative way utilizing
a one-way data flow.

⚠️ It is currently a work in progress proof of concept with very limited functionality. ⚠️

# About

Using UILib you create scenes in your app by creating a `ComponentContainer`. A component container stores the state for a specific scene
and provides a `render` function to produce the view for that scene. Whenever the state in a `ComponentContainer` updates, the `render` function is invoked.
The `render` function will produce a component tree for each state update.

UILib will take that component tree and generate the necessary UI components to render it. On subsequent state updates UILib will compare the current container tree to the
new one and update the UIKit representation automatically. This allows developers to write views declaratively without worrying about how they need to be updated.


# Example

Here's an example of a `ComponentContainer` for a login view:

(TODO: Replace with much simpler example!)

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

# Goals Of This Library

- Develop a proof of concept to see if we can wrap UIKit into a declarative view layer that we can use in production apps
- Make the library as uninvasive as possible: make it use system components; make it easy to use with existing UI components
- Use native UI APIs on the rendering layer to get full functionality of complex UI components, such as table views and collection views

# Technical Details

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

## Component Tree, Render Tree and Changeset Tree

*Note: The notes in this section are not polished and mostly ment for myself; so don't worry if you don't understand them!*

UILib uses three different trees in order to perform diffing on component trees and delta updates on UIKit components. The component tree is emmited from the `render` function and contains all components that participate in diffing. UILib will use this tree to calculate changes in a diffing function. From these changes it will generate a changeset tree. The changeset tree describes different types of changes that can be applied to container components or individual components. The `.Root, `.Delete` and `.Insert` changes are only applicable to container components, as they influence how their child components are updated.

When applying the changes to an existing view hierarchy, we traverse the changeset tree and the render tree in parallel to find the relevant components to which changes need to be applied.

The render tree is separate from the component tree. The render tree stores components and their view representations side-by-side. The render tree consists of `.Nodes` and `.Leafs`. The distinction is imporant for understanding how changes are applied to parts of the render tree. When `.Nodes` receive `.Root` changes, they update their children tree by performing insertions & deletions, but they are **not responsible for updating the children that are not removed/added**. Since they are `.Nodes`, their children have their own representation in the render tree; UILib will pass their relevant changes to the children separately. 

`.Leafs` on the other hand mark the end of the render tree. None of their potentially existing child components have a representation in the render tree; therefore they cannot be updated automatically. When `.Leafs` receive `.Root` changes, they are responsible for updating themselves **and all of their child components**. A current example for a container component that acts as a leaf in the render tree is the Table View. The Table View needs to update its children manually, since UILib should not interfere with the way updates work within `UITableViews`. If each of the child components of the table view would also be represented in the render tree; the deletion of a `UITableViewCell` would be the responsibility of its parent component, a `UITableViewSection`. However, in UIKit it is not possible for a section to delete a cell; such kind of changes have to happen through the table view's data source and delegate and these are maintained by the table view component. By acting as a `.Leaf` the table view can opt out of the automatic container changes and can receive all changes for any of the components below it in the component tree.

### Animated State Changes

UILib supports a very naive way of rendering state changes. When mutating the state in a component container the update can be wrapped in a `updateAnimated` block:

```swift
self.updateAnimated {
	self.state.usernameValid = false
	self.state.passwordValid = false
}
```
The resulting changes will then be rendered within a `UIView.animateWithDuration...` block.

### State Changes Without Re-Render

UILib provides another special way to perform updates that works around two-way binding issues. If we want to update the state in response to an update that we received from a UI component (e.g. user entered a new text), then we want to avoid a re-render when we update the state. This can be done as following:

```swift
@objc func usernameChanged(newValue: UITextField) {
    self.updateNoRender {
        self.state.username = newValue.text ?? ""
    }
}
```

# Similar Projects

Check out [Few.swift](https://github.com/joshaber/Few.swift) by Josh Abernathy which has the same goal and is more mature (even though it's experimental as well). One of the major differences is that Few.swift uses CSS layout, just as React does.