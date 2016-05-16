//
//  UserListComponent.swift
//  UILib
//
//  Created by Benji Encz on 5/14/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

extension TableViewModel: UIKitRenderable {

    func renderUIKit() -> UIKitRenderTree {
        let tableViewRenderer = TableViewRenderer(
            cellTypes: self.cellTypeDefinitions
        )

        tableViewRenderer.tableViewModel = self

        return .Leaf(self, tableViewRenderer)
    }

    func updateUIKit(view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let view = view as? TableViewRenderer else { fatalError() }
        guard let newComponent = newComponent as? TableViewModel else { fatalError() }

        // Update view model
        view.tableViewModel = newComponent

        if case let .Root(changes) = change {
            // need to check which sections / rows are affected
            for (sectionIndex, change) in changes.enumerate() {
                if case let .Root(changes) = change {
                    for (rowIndex, change) in changes.enumerate() {
                        switch change {
                        case let .Remove(row):
                            view.tableView.deleteRowsAtIndexPaths(
                                [NSIndexPath(forRow: row, inSection: sectionIndex)],
                                withRowAnimation: .Automatic
                            )
                        case let .Insert(row, _):
                            view.tableView.insertRowsAtIndexPaths(
                                [NSIndexPath(forRow: row, inSection: sectionIndex)],
                                withRowAnimation: .Automatic
                            )
                        default:
                            break
                        }
                    }
                }
            }
        }

        return .Leaf(newComponent, view)
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
