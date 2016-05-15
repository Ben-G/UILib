//
//  ComponentContainer.swift
//  UILib
//
//  Created by Benji Encz on 5/14/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

protocol Renderer: class {
    func renderComponent(component: ContainerComponent)
}

class BaseComponentContainer<State> {

    weak var renderer: Renderer? {
        didSet {
            let component = self.render(state)
            self.renderer?.renderComponent(component)
        }
    }

    var state: State {
        didSet {
            let component = self.render(state)
            self.renderer?.renderComponent(component)
        }
    }

    init(state: State) {
        self.state = state
        let component = self.render(state)
        self.renderer?.renderComponent(component)
    }

    func render(state: State) -> ContainerComponent {
        fatalError()
    }
    
}
