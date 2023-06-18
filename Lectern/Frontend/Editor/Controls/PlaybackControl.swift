//
//  PlaybackControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct PlaybackControl: View {

    @Environment(ContentManager.self) var cm

    @State var bounced = true
    @State var pauseTranscribe = false

    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 16) {
            Spacer()

            SymbolButton(symbol: "backward.fill")

            Group {
                if cm.studyState == .transcribingPaused {
                    HStack(spacing: 10) {
                        SymbolButton(symbol: "mic.slash.fill") {
                            withAnimation(.snappy) {
                                cm.studyState = .blurting
                            }
                        }

                        VerticalBar(color: Color(.secondarySystemFill), height: 19)

                        SymbolButton(symbol: "checkmark") {
                            cm.blurt()
                        }
                    }
                } else {
                    SymbolButton(symbol: "waveform") {
                        withAnimation(.snappy) {
                            cm.studyState = .transcribingPaused
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
