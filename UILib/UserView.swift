//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

enum ABState {
    case A
    case B
}

struct UserViewState {
    var abState: ABState

    var users: [String]
}

class UserComponentContainer: BaseComponentContainer<UserViewState> {

    override init(state: UserViewState) {
        super.init(state: state)
    }

    @objc func editButtonTapped(button: AnyObject) {
        self.state.abState = .B
    }

    @objc func backButtonTapped(button: AnyObject) {
        self.state.abState = .A
    }

    @objc func addButtonTapped(button: AnyObject) {
        self.state.users.append("More Items!")
    }

    func deleteRow(indexPath: NSIndexPath) {
        self.state.users.removeAtIndex(indexPath.row)
    }

    override func render(state: UserViewState) -> ContainerComponent {
        switch state.abState {
        case .A:
            return {
                let navigationBar = NavigationBarComponent(
                    leftBarButton: nil,
                    rightBarButton: BarButton(
                        title: "Edit",
                        onTapTarget: self,
                        onTapSelector: #selector(editButtonTapped)
                    ),
                    title: "Test Title"
                )

                let placeholder = VerticalMargin(margin: 20.0, color: Color(hexString: "lightGray"))
                let mainView = VerticalMargin(margin: 100.0, color: Color(hexString: "lightGray"))

                let stackView = StackComponent(childComponents: [
                    placeholder,
                    navigationBar,
                    mainView
                    ], backgroundColor: Color(hexString: "whiteColor"))
                
                return stackView
            }()
        case .B:
            return {
                let navigationBar = NavigationBarComponent(
                    leftBarButton: BarButton(
                        title: "Back",
                        onTapTarget: self,
                        onTapSelector: #selector(backButtonTapped)
                    ),
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

                let stackView = StackComponent(childComponents: [
                    placeholder,
                    navigationBar,
                    tableViewModel
                    ], backgroundColor: Color(hexString: "whiteColor"))
                
                return stackView
            }()
        }
    }

    func cellModelForUser(user: String, onDelete: (NSIndexPath) -> Void) -> TableViewCellModel {
            return TableViewCellModel(
                cellIdentifier: "UserCell",
                applyViewModelToCell: applyViewModelUserCell(user),
                commitEditingClosure: onDelete
            )
    }

}
