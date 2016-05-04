//
//  TableViewCellModel.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

struct TableViewCellModel {
    let cellIdentifier: String
    let canEdit: Bool = false

    var applyViewModelToCell: (UITableViewCell) -> Void

    init(cellIdentifier: String, applyViewModelToCell: (UITableViewCell) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.applyViewModelToCell = applyViewModelToCell
    }
}
