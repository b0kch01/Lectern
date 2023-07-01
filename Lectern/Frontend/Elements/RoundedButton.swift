//
//  RoundedButton.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct RoundedButton: View {

    private var symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: UIConstants.subhead).weight(.semibold))
            .foregroundStyle(.mainColorInvert)
            .padding(.vertical, 9)
            .padding(.horizontal, 24)
            .background(.main)
            .clipShape(RoundedRectangle(cornerRadius: 39, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 20)
    }
}
