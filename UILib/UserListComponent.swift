//
//  UserListComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/14/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension TableViewModel: UIKitRenderable {

    func renderUIKit() -> UIView {
        let tableViewRenderer = TableViewRenderer(
            cellTypes: self.cellTypeDefinitions
        )

        tableViewRenderer.tableViewModel = self

        return tableViewRenderer
    }

}


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
