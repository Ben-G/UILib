//
//  UserView.swift
//  UILib
//
//  Created by Benji Encz on 5/3/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

func userView(users: [String]) -> TableViewModel {
    return TableViewModel(
        sections: [
            TableViewSectionModel(
                cells: users.map(cellModelForUser)
            )
        ]
    )
}

func cellModelForUser(user: String) -> TableViewCellModel {
    return TableViewCellModel(
        cellIdentifier: "UserCell"
    ) { cell in
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user
    }
}
