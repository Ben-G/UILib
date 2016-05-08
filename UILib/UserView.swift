//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

protocol UserViewActionHandlerType {
    func deleteUser(indexPath: NSIndexPath)
}

func userView(users: [String], actionHandler: UserViewActionHandlerType) -> TableViewModel {
    return TableViewModel(
        sections: [
            TableViewSectionModel(
                cells: users.map(cellModelForUser(actionHandler))
            )
        ]
    )
}

func cellModelForUser(actionHandler: UserViewActionHandlerType) -> (user: String) -> TableViewCellModel {

    return { user in

        func applyViewModelToCell(cell: UITableViewCell) {
            guard let cell = cell as? UserCell else { return }
            cell.nameLabel.text = user
        }

        func commitEditingClosure(indexPath: NSIndexPath) {
            actionHandler.deleteUser(indexPath)
        }

        return TableViewCellModel(
            cellIdentifier: "UserCell",
            applyViewModelToCell: applyViewModelToCell,
            commitEditingClosure: commitEditingClosure
        )

    }

}
