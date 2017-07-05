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

        return .leaf(self, tableViewRenderer)
    }

    func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let view = view as? TableViewRenderer else { fatalError() }
        guard let newComponent = newComponent as? TableViewModel else { fatalError() }

        // Update view model
        view.tableViewModel = newComponent

        if case let .root(changes) = change {
            // need to check which sections / rows are affected
            for (sectionIndex, change) in changes.enumerated() {
                if case let .root(changes) = change {
                    for (_, change) in changes.enumerated() {
                        switch change {
                        case let .remove(row):
                            view.tableView.deleteRows(
                                at: [IndexPath(row: row, section: sectionIndex)],
                                with: .automatic
                            )
                        case let .insert(row, _):
                            view.tableView.insertRows(
                                at: [IndexPath(row: row, section: sectionIndex)],
                                with: .automatic
                            )
                        default:
                            break
                        }
                    }
                }
            }
        }

        return .leaf(newComponent, view)
    }

}

