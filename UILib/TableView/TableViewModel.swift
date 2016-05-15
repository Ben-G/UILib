//
//  TableViewModel.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct TableViewModel: Component {

    var editingMode: Bool = false
    let sections: [TableViewSectionModel]
    let cellTypeDefinitions: [CellTypeDefinition]

    init(sections: [TableViewSectionModel], cellTypeDefinitions: [CellTypeDefinition]) {
        self.sections = sections
        self.cellTypeDefinitions = cellTypeDefinitions
    }

    subscript(indexPath: NSIndexPath) -> TableViewCellModel {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}
