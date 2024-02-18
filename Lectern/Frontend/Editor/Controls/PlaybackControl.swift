//
//  PlaybackControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct PlaybackControl: View {
    var body: some View {
        HStack(spacing: 10) {
            Spacer()

            SymbolButton(symbol: "backward.fill")

            SymbolButton(symbol: "mic")


            SymbolButton(symbol: "forward.fill")

            Spacer()
        }
    }
}
