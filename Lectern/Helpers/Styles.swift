//
//  Styles.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension View {
    func controlStyle(colorScheme: ColorScheme) -> some View {
        self
            .background(Blur(.systemChromeMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.borderBackground, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 30, y: 10)
            .contentShape(Rectangle())
    }

    func modalStyle() -> some View {
        self
            .background(Color.elevatedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.borderBackground, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
            .padding([.horizontal, .bottom], 11)
    }
}
