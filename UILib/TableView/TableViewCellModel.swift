//
//  TableViewCellModel.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

typealias CommitEditingClosure = (NSIndexPath) -> Void

struct TableViewCellModel: Component {
    let cellIdentifier: String
    let canEdit: Bool
    let commitEditingClosure: CommitEditingClosure
    let applyViewModelToCell: (UITableViewCell) -> Void

    init(
        cellIdentifier: String,
        applyViewModelToCell: (UITableViewCell) -> Void,
        commitEditingClosure: CommitEditingClosure
    ) {
        self.cellIdentifier = cellIdentifier
        self.applyViewModelToCell = applyViewModelToCell
        self.commitEditingClosure = commitEditingClosure
        self.canEdit = true
    }
}
