//
//  TableViewModel.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct TableViewModel {

    let sections: [TableViewSectionModel]

    subscript(indexPath: NSIndexPath) -> TableViewCellModel {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}
