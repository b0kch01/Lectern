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
    var color: Color
    var fill: Color
    var action: (() -> Void)?

    init(symbol: String, color: Color = .main, fill: Color = Color.clear, action: (() -> Void)?=nil) {
        self.symbol = symbol
        self.color = color
        self.fill = fill
        self.action = action
    }

    var body: some View {
        Button(action: {
            action?()
            tapped.toggle()
        }) {
            Image(systemName: symbol)
                .font(.system(size: UIConstants.body).weight(.medium))
                .symbolEffect(.bounce, value: tapped)
                .frame(width: 18, height: 18)
                .padding(sizeClass == .compact ? 13 : 15)
                .background(fill)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .contentShape(Rectangle())
                .hoverEffect(.highlight)
        }
    }
}
