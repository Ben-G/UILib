//
//  TableViewRenderer.swift
//  UILib
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

protocol Renderer {
    var view: UIView { get }
}

struct CellTypeDefinition {
    let nibFilename: String
    let cellIdentifier: String
}

public final class TableViewRenderer: UIView, Renderer {

    var view: UIView { return self }

    let tableViewModel: TableViewModel
    let cellTypes: [CellTypeDefinition]

    let tableView: UITableView

    init(tableViewModel: TableViewModel, cellTypes: [CellTypeDefinition]) {
        self.tableViewModel = tableViewModel
        self.cellTypes = cellTypes

        self.tableView = UITableView(frame: CGRect.zero)

        super.init(frame: CGRect.zero)

        self.tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        for cellType in cellTypes {
            let nibFile = UINib(nibName: cellType.cellIdentifier, bundle: nil)
            self.tableView.registerNib(nibFile, forCellReuseIdentifier: cellType.cellIdentifier)
        }

        self.addSubview(self.tableView)

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TableViewRenderer: UITableViewDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableViewModel.sections.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellViewModel = self.tableViewModel[indexPath]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellViewModel.cellIdentifier) ?? UITableViewCell()
        cellViewModel.applyViewModelToCell(cell)

        return cell
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewModel.sections[section].cells.count
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableViewModel.sections[section].sectionHeaderTitle
    }

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.tableViewModel.sections[section].sectionFooterTitle
    }

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.tableViewModel[indexPath].canEdit
    }

}

extension TableViewRenderer: UITableViewDelegate {

}

//
//// Editing
//
//// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
//
//// Moving/reordering
//
//// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
//
//// Index
//
//@available(iOS 2.0, *)
//optional public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
//
//// Data manipulation - insert and delete support
//
//// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
//
//// Data manipulation - reorder / moving support
//
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)