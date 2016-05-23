//
//  Reconciler.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

func diffChanges(oldTree: ContainerComponent, newTree: ContainerComponent) -> Changes {
    var changes: [Changes] = []

    for component in oldTree.childComponents {
        if component is ContainerComponent {
            // and start out with no changes for container components
            changes.append(.None)
        } else {
            // start out with the assumption that we need to update every regular component
            changes.append(.Update)
        }
    }

    let diff = oldTree.childComponents.map{ $0.componentIdentifier }
        .diff(newTree.childComponents.map { $0.componentIdentifier })

    diff.results.forEach { diffStep in
        switch diffStep {
        case let .Insert(index, identifier):
            changes.append(.Insert(index: index, identifier: identifier))
        case let .Delete(index, _):
            changes[index] = .Remove(index: index)
        }
    }

    for (index, component) in oldTree.childComponents.enumerate() {
        guard case .None = changes[index] else { continue }

        if let container = component as? ContainerComponent {
            // recursively reconcile; force cast is OK here for now since we know component is of identical type
            // since that was checked in the diffing step
            changes[index] = diffChanges(
                container,
                newTree: newTree.childComponents[index] as! ContainerComponent
            )
        }
    }

    return .Root(changes)
}
