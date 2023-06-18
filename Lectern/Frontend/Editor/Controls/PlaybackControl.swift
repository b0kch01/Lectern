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
        HStack(spacing: 10) {
            Spacer()

            SymbolButton(symbol: "backward.fill")

            Group {
                if cm.studyState == .transcribingPaused {
                    HStack(spacing: 7) {
                        SymbolButton(symbol: "mic.slash.fill") {
                            withAnimation(.snappy) {
                                cm.sr.startTranscribing()
                                cm.studyState = .transcribing
                            }
                        }

                        VerticalBar(color: Color(.secondarySystemFill), height: 19)

                        SymbolButton(symbol: "checkmark") {
                            cm.blurt()
                        }
                    }
                } else if cm.study.count == 0 {
                    SymbolButton(symbol: "waveform") {
                        withAnimation(.snappy) {
                            cm.blurtVM.savedText += cm.blurtVM.mainText
                            cm.blurtVM.mainText = []
                            cm.sr.stopTranscribing()
                            cm.sr.transcript = ""
                            cm.studyState = .transcribingPaused
                        }
                    }
                    .symbolEffect(.pulse)
                    .symbolEffect(.bounce, value: bounced)
                } else {
                    SymbolButton(symbol: "arrow.counterclockwise") {
                        withAnimation(.snappy) {
                            cm.blurtVM.savedText = []
                            cm.blurtVM.mainText = []
                            cm.sr.resetTranscript()
                            cm.sr.startTranscribing()
                            cm.studyState = .transcribing
                        }
                    }
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.mainColorInvert)
                        .frame(width: 21, height: 21)
                        .padding(7)
                        .background(cm.studyState == .transcribingPaused ? Color(.tertiarySystemFill) : .main)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                        .contentShape(Rectangle())
                        .hoverEffect(.highlight)
                        .padding(.top, 10)
                }
            }

            SymbolButton(symbol: "forward.fill") {
                cm.blurtVM.savedText = []
                cm.blurtVM.mainText = []
                cm.sr.stopTranscribing()
                cm.sr.transcript = ""
                cm.studyState = .transcribingPaused
            }

            Spacer()
        }
        .onReceive(timer) { _ in
            bounced.toggle()
        }
    }
}
