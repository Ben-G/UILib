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
                    for (_, change) in changes.enumerate() {
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

