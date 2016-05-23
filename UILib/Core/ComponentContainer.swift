//
//  ComponentContainer.swift
//  UILib
//
//  Created by Benji Encz on 5/14/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

protocol Renderer: class {
    func renderComponent(component: ContainerComponent, animated: Bool)
}

protocol ComponentContainer {
    weak var renderer: Renderer? { get set }
}

class BaseComponentContainer<State>: ComponentContainer {

    weak var renderer: Renderer? {
        didSet {
            guard !_noRender else { return }

            let component = self.render(state)
            self.renderer?.renderComponent(component, animated: self._animateChanges)
        }
    }

    var state: State {
        didSet {
            let component = self.render(state)
            self.renderer?.renderComponent(component, animated: self._animateChanges)
        }
    }

    init(state: State) {
        self.state = state
        let component = self.render(state)
        self.renderer?.renderComponent(component, animated: self._animateChanges)
    }

    var _noRender = false
    var _animateChanges = false

    func updateNoRender(update: () -> Void) {
        self._noRender = true
        update()
        self._noRender = false
    }

    func updateAnimated(update: () -> Void) {
        self._animateChanges = true
        update()
        self._animateChanges = false
    }

    func render(state: State) -> ContainerComponent {
        fatalError()
    }
    
}
