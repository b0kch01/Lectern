//
//  ButtonStyles.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.05 : 0)
        // .animation(.spring(response: 0.25, dampingFraction: 1), value: configuration.isPressed)
    }
}

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.3 : 1)
            .scaleEffect(configuration.isPressed ? 0.93 : 1)
        // .animation(.spring(response: 0.25, dampingFraction: 1), value: configuration.isPressed)
    }
}

struct OptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.3 : 1)
    }
}

struct ShrinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
        // .animation(.spring(response: 0.25, dampingFraction: 1), value: configuration.isPressed)
    }
}

struct NoteButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.04 : 1)
            .animation(.dragSpring, value: configuration.isPressed)
    }
}
