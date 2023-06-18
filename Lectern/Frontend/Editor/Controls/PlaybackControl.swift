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

            SymbolButton(symbol: "backward.fill") {
                cm.blurtVM.savedText = []
                cm.blurtVM.mainText = ["Unmute to start blurting..."]
                cm.study = [:]
                cm.sr.stopTranscribing()
                cm.sr.transcript = ""
                cm.studyState = .transcribingPaused
                cm.skip(n: -1)
            }

            Group {
                if cm.studyState == .blurting {
                    ProgressView()
                } else if cm.studyState == .transcribingPaused {
                    HStack(spacing: 10) {
                        SymbolButton(symbol: "mic.slash.fill", color: .red) {
                            withAnimation(.snappy) {
                                cm.sr.startTranscribing()
                                cm.studyState = .transcribing
                            }
                        }

                        if cm.blurtVM.mainText.count + cm.blurtVM.savedText.count > 5 {
                            SymbolButton(symbol: "checkmark") {
                                cm.blurt()
                            }
                        }
                    }
                } else if cm.study.count == 0 {
                    HStack(spacing: 10) {
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

                        if cm.blurtVM.mainText.count + cm.blurtVM.savedText.count > 5 {
                            SymbolButton(symbol: "checkmark") {
                                cm.blurt()
                            }
                        }
                    }
                } else {
                    SymbolButton(symbol: "arrow.counterclockwise") {
                        withAnimation(.snappy) {
                            cm.blurtVM.savedText = []
                            cm.blurtVM.mainText = []
                            cm.study = [:]
                            cm.sr.resetTranscript()
                            cm.sr.startTranscribing()
                            cm.studyState = .transcribing
                        }
                    }
                }
            }

            SymbolButton(symbol: "forward.fill") {
                cm.blurtVM.savedText = []
                cm.blurtVM.mainText = ["Unmute to start blurting..."]
                cm.study = [:]
                cm.sr.stopTranscribing()
                cm.sr.transcript = ""
                cm.studyState = .transcribingPaused
                cm.skip(n: 1)
            }

            Spacer()
        }
        .onReceive(timer) { _ in
            bounced.toggle()
        }
    }
}
