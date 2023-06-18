//
//  PlaybackControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct PlaybackControl: View {

    @State var bounced = true
    @State var pauseTranscribe = false

    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 16) {
            Spacer()

            SymbolButton(symbol: "backward.fill")

            Group {
                if pauseTranscribe {
                    HStack(spacing: 10) {
                        SymbolButton(symbol: "mic.slash.fill") {
                            withAnimation(.snappy) {
                                pauseTranscribe = false
                            }
                        }

                        VerticalBar(color: Color(.secondarySystemFill), height: 19)

                        SymbolButton(symbol: "checkmark") { }
                    }
                } else {
                    SymbolButton(symbol: "waveform") {
                        withAnimation(.snappy) {
                            pauseTranscribe = true
                        }
                    }
                    .symbolEffect(.pulse)
                    .symbolEffect(.bounce, value: bounced)
                }
            }

            SymbolButton(symbol: "forward.fill")

            Spacer()
        }
        .onReceive(timer) { _ in
            bounced.toggle()
        }
    }
}
