//
//  Animation.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension Animation {

    static let defaultSpring = Animation.smooth(duration: 0.39, extraBounce: 0.2)

    static let snapSpring = Animation.interpolatingSpring(
        mass: 0.75,
        stiffness: 250,
        damping: 21,
        initialVelocity: 0
    )

    static let snapSpringiPad = Animation.interpolatingSpring(
        mass: 0.75,
        stiffness: 150,
        damping: 17,
        initialVelocity: 0
    )

    static let dragSpring = Animation.interpolatingSpring(
        mass: 0.75,
        stiffness: 250,
        damping: 30,
        initialVelocity: 0
    )

    static let dragSpringiPad = Animation.interpolatingSpring(
        mass: 0.75,
        stiffness: 150,
        damping: 20,
        initialVelocity: 0
    )

    static let quickSpring = Animation.spring(duration: 0.01, bounce: 0)

    static let flipSpring = Animation.interpolatingSpring(
        mass: 0.75,
        stiffness: 250,
        damping: 22,
        initialVelocity: 0
    )
}
