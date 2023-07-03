//
//  SymbolButton.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct SymbolButton: View {

    @Environment(\.horizontalSizeClass) var sizeClass

    @State var tapped = false

    var symbol: String
    var foreground: Color
    var background: Color
    var action: (() -> Void)?

    init(symbol: String, foreground: Color = .main, background: Color = Color.clear, action: (() -> Void)?=nil) {
        self.symbol = symbol
        self.foreground = foreground
        self.background = background
        self.action = action
    }

    var body: some View {
        Button(action: {
            action?()
            tapped.toggle()
        }) {
            Image(systemName: symbol)
                .font(.system(size: 17 + (symbol == "waveform" || symbol == "pause.fill" ? 3 : 0)).weight(.medium))
                .foregroundStyle(foreground)
                .symbolEffect(.bounce, value: tapped)
                .frame(width: 21, height: 21)
                .padding(9)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .padding(5)
                .contentShape(Rectangle())
                .hoverEffect(.highlight)
        }
    }
}
