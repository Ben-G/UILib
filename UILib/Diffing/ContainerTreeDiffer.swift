//
//  Reconciler.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

/**
 Derives a set of changes based on a old and new `ContainerComponent`.
*/
func diffChanges(oldTree: ContainerComponent, newTree: ContainerComponent) -> Changes {
    var changes: [Changes] = []

    for component in oldTree.childComponents {
        if component is ContainerComponent {
            // start out with the assumption that we need to update none of the container
            // components
            changes.append(.None)
        } else {
            // start out with the assumption that we need to update every regular component
            changes.append(.Update)
        }
    }

    // Use dwifft to compare the old to the new tree
    let diff = oldTree.childComponents.map{ $0.componentIdentifier }
        .diff(newTree.childComponents.map { $0.componentIdentifier })

    var insertedIndexes: [Int] = []
    var removedIndexes: [Int] = []

    // Iterate over all changes we found while diffing
    diff.results.forEach { diffStep in
        switch diffStep {
        case let .Insert(index, identifier):
            // If we detect insertions, simply append these two our change list
            changes.append(.Insert(index: index, identifier: identifier))
            insertedIndexes.append(index)
        case let .Delete(index, _):
            // If we detect deletes, place them at the child component index that is about
            // to be deleted. This will override the default value we inserted earlier for 
            // this component.
            changes[index] = .Remove(index: index)
            removedIndexes.append(index)
        }
    }

    // Iterate over all components allready in the tree and recursively check for updates
    for (index, component) in oldTree.childComponents.enumerate() {
        // Revisit all old components that currently have a `.None` set of changes
        // Deleted or inserted types don't need to be checked for child component changes since they
        // are either being removed from the tree or are entirely new.
        guard case .None = changes[index] else { continue }

        // Calculate mapping between index in new and old tree by counting insertions and
        // deletions that affect the current index
        let newComponentOffset: Int = {
            let insertOffsets = insertedIndexes.filter { $0 <= index }.count
            let removeOffsets = removedIndexes.filter { $0 < index }.count

            return insertOffsets - removeOffsets
        }()

        // In this step we only care about container components
        if let container = component as? ContainerComponent {
            // Recursively reconcile this child component.
            // It's OK to force cast the new child component here, for now, since we know the new
            // component is of identical type as the old component since that was checked in the 
            // diffing step.
            changes[index] = diffChanges(
                container,
                newTree: newTree.childComponents[index + newComponentOffset] as! ContainerComponent
            )
        }
    }

    // Combine all of the changes on this level into a `Root` change for the container component
    return .Root(changes)
}
