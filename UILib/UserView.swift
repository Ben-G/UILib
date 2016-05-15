//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

enum UserViewState {
    case A
    case B
}

class UserComponentContainer: BaseComponentContainer<UserViewState> {

    override init(state: UserViewState) {
        super.init(state: state)
    }

    @objc func editButtonTapped(button: AnyObject) {
        self.state = .B
    }

    @objc func backButtonTapped(button: AnyObject) {
        self.state = .A
    }

    override func render(state: UserViewState) -> Component {
        switch state {
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

                let stackView = StackComponent(components: [
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
                    rightBarButton: nil,
                    title: "Second Title"
                )

                let placeholder = VerticalMargin(margin: 20.0, color: Color(hexString: "lightGray"))

                let cellTypes = [CellTypeDefinition(
                    nibFilename: "UserCell",
                    cellIdentifier: "UserCell"
                    )]
                
                let initialState = [
                    "OK",
                    "Benji",
                    "Another User"
                ]

                let tableViewModel = TableViewModel(
                    sections: [
                        TableViewSectionModel(
                            cells: initialState.map(self.cellModelForUser)
                        )
                    ],
                    cellTypeDefinitions: cellTypes
                )

                let stackView = StackComponent(components: [
                    placeholder,
                    navigationBar,
                    tableViewModel
                    ], backgroundColor: Color(hexString: "whiteColor"))
                
                return stackView
            }()
        }
    }

    func cellModelForUser(user: String) -> TableViewCellModel {
            return TableViewCellModel(
                cellIdentifier: "UserCell",
                applyViewModelToCell: applyViewModelUserCell(user),
                commitEditingClosure:  { _ in }
            )
    }

}
