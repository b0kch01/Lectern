//
//  PresetText.swift
//  Lectern
//
//  Created by Paul Wong on 7/3/23.
//

import SwiftUI
import FluidGradient

struct PresetText <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .font(.title3.weight(.semibold))
            .lineSpacing(7)
            .foregroundStyle(Color.gray)
            .multilineTextAlignment(.trailing)
            .overlay(
                FluidGradient(
                    blobs: [
                        Color(.systemBackground).opacity(0.3),
                        Color(.systemBackground).opacity(0.9)
                    ],
                    highlights: [
                        .white.opacity(0.5),
                        Color.yellow.opacity(0.7)
                    ],
                    speed: 0.7,
                    blur: 0.9
                )
                .mask(
                    content
                        .font(.title3.weight(.semibold))
                        .lineSpacing(7)
                        .multilineTextAlignment(.trailing)
                )
            )
    }
}
