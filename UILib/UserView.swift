//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

func viewForStateA(target: AnyObject, selector: Selector) -> UIKitRenderable {
    let navigationBar = NavigationBarComponent(
        leftBarButton: nil,
        rightBarButton: BarButton(title: "Edit", target: target, selector: selector),
        title: "Test Title"
    )

    let placeholder = VerticalMargin(margin: 20.0, color: Color(hexString: "lightGray"))
    let mainView = VerticalMargin(margin: 100.0, color: Color(hexString: "lightGray"))

    let stackView = StackComponent(components: [
        placeholder,
        navigationBar,
        mainView
    ], backgroundColor: Color(hexString: "whiteColor"))

    return stackView
}

func viewForStateB() -> UIKitRenderable {

    let navigationBar = NavigationBarComponent(
        leftBarButton: nil,
        rightBarButton: nil,
        title: "Second Title"
    )

    let placeholder = VerticalMargin(margin: 20.0, color: Color(hexString: "lightGray"))

    let stackView = StackComponent(components: [
        placeholder,
        navigationBar
    ], backgroundColor: Color(hexString: "whiteColor"))

    return stackView
}
//
//
//
//
//
//let cellTypes = [CellTypeDefinition(
//    nibFilename: "UserCell",
//    cellIdentifier: "UserCell"
//    )]
//
//let initialState = [
//    "OK",
//    "Benji",
//    "Another User"
//]
//
//let userViewComponent = UserViewComponent(state: initialState)
//
//final class UserViewComponent: UserViewActionHandlerType, Component {
//
//    private (set) var state: [String]
//
//    init(state: [String]) {
//        self.state = state
//    }
//
//    func deleteUser(indexPath: NSIndexPath) {
//        self.state.removeAtIndex(indexPath.row)
//
////        renderer.newViewModelWithChangeset(
////            userView(state, actionHandler: self),
////            changeSet: .Delete(indexPath)
////        )
//    }
//}
//
//
//protocol UserViewActionHandlerType {
//    func deleteUser(indexPath: NSIndexPath)
//}
//
//func userView(users: [String], actionHandler: UserViewActionHandlerType) -> TableViewModel {
//    return TableViewModel(
//        sections: [
//            TableViewSectionModel(
//                cells: users.map(cellModelForUser(actionHandler))
//            )
//        ]
//    )
//}
//
//struct UserCellComponent: Component {
//    let user: String
//}
//
//func cellModelForUser(actionHandler: UserViewActionHandlerType) -> (user: String) -> TableViewCellModel {
//
//    return { user in
//
//        func applyViewModelToCell(cell: UITableViewCell) {
//            guard let cell = cell as? UserCell else { return }
//            cell.nameLabel.text = user
//        }
//
//        func commitEditingClosure(indexPath: NSIndexPath) {
//            actionHandler.deleteUser(indexPath)
//        }
//
//        return TableViewCellModel(
//            cellIdentifier: "UserCell",
//            applyViewModelToCell: applyViewModelToCell,
//            commitEditingClosure: commitEditingClosure
//        )
//
//    }
//
//}
