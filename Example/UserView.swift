//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var uid: String = NSUUID().UUIDString

    init(_ name: String) {
        self.name = name
    }
}

struct UserViewState {
    var users: [User]
}

class UserComponentContainer: BaseComponentContainer<UserViewState> {

    override init(state: UserViewState) {
        super.init(state: state)
    }

    @objc func addButtonTapped(button: AnyObject) {
        self.state.users.append(User("Another User!"))
    }

    func deleteRow(indexPath: NSIndexPath) {
        self.state.users.removeAtIndex(indexPath.row)
    }

    override func render(state: UserViewState) -> ContainerComponent {
        let navigationBar = NavigationBarComponent(
            leftBarButton: nil,
            rightBarButton: BarButton(
                title: "Add Item",
                onTapTarget: self,
                onTapSelector: #selector(addButtonTapped)
            ),
            title: "Second Title"
        )

        let placeholder = VerticalMargin(margin: 20.0, color: Color(hexString: "lightGray"))

        let cellTypes = [CellTypeDefinition(
            nibFilename: "UserCell",
            cellIdentifier: "UserCell"
            )]

        let tableViewModel = TableViewModel(
            sections: [
                TableViewSectionModel(
                    cells: state.users.map {
                        self.cellModelForUser($0, onDelete: self.deleteRow)
                    }
                )
            ],
            cellTypeDefinitions: cellTypes
        )

        let stackView = StackComponent(
            backgroundColor: Color(hexString: "whiteColor"),
            childComponents: [
                placeholder,
                navigationBar,
                tableViewModel
            ]
        )

        return stackView
    }

    func cellModelForUser(user: User, onDelete: (NSIndexPath) -> Void) -> TableViewCellModel {
            return TableViewCellModel(
                cellIdentifier: "UserCell",
                componentIdentifier: user.uid,
                applyViewModelToCell: applyViewModelUserCell(user.name),
                commitEditingClosure: onDelete
            )
    }

}
