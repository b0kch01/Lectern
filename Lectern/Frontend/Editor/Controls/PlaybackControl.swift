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
                cm.blurtVM.mainText = [""]
                cm.study = [:]
                cm.sr.stopTranscribing()
                cm.sr.transcript = ""
                cm.studyState = .transcribingPaused
                cm.skip(n: -1)
            }

            Group {
                if cm.studyState == .blurting {
                    ProgressView()
                } else if cm.studyState == .transcribingPaused || cm.studyState == .practicingPaused {
                    HStack(spacing: 10) {
                        SymbolButton(symbol: "mic.slash.fill", foreground: .red) {
                            withAnimation(.snappy) {
                                cm.sr.startTranscribing()
                                if cm.studyState == .practicingPaused {
                                    cm.studyState = .practicing
                                } else {
                                    cm.studyState = .transcribing
                                }
                            }
                        }

                        if cm.blurtVM.mainText.count + cm.blurtVM.savedText.count > 5 {
                            SymbolButton(symbol: "checkmark") {
                                cm.blurtVM.savedText += cm.blurtVM.mainText
                                cm.blurtVM.mainText = []
                                cm.sr.stopTranscribing()
                                if cm.studyState == .practicing || cm.studyState == .practicingPaused {
                                    cm.practice()
                                } else {
                                    cm.blurt()
                                }
                            }
                        }
                    }
                } else if cm.study.count == 0 || cm.studyState == .practicing {
                    HStack(spacing: 10) {
                        SymbolButton(symbol: "waveform") {
                            withAnimation(.snappy) {
                                cm.blurtVM.savedText += cm.blurtVM.mainText
                                cm.blurtVM.mainText = []
                                cm.sr.stopTranscribing()
                                cm.sr.transcript = ""

                                if cm.studyState == .practicing {
                                    cm.studyState = .practicingPaused
                                } else {
                                    cm.studyState = .transcribingPaused
                                }
                            }
                        }
                        .symbolEffect(.pulse)
                        .symbolEffect(.bounce, value: bounced)

                        if cm.blurtVM.mainText.count + cm.blurtVM.savedText.count > 5 {
                            SymbolButton(symbol: "checkmark") {
                                cm.blurtVM.savedText += cm.blurtVM.mainText
                                cm.blurtVM.mainText = []
                                cm.sr.stopTranscribing()
                                if cm.studyState == .practicing || cm.studyState == .practicingPaused {
                                    cm.practice()
                                } else {
                                    cm.blurt()
                                }
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

                            if cm.studyState == .practicingPaused {
                                cm.studyState = .practicing
                            } else {
                                cm.studyState = .transcribing
                            }
                        }
                    }
                }
            }

            SymbolButton(symbol: "forward.fill") {
                cm.blurtVM.savedText = []
                cm.blurtVM.mainText = [""]
                cm.study = [:]
                cm.sr.stopTranscribing()
                cm.sr.transcript = ""
                cm.studyState = .transcribingPaused
                cm.skip(n: 1)
                print("SKIPPING MULTIPLE TIMES")
            }

            Spacer()
        }
        .onReceive(timer) { _ in
            bounced.toggle()
        }
    }
}
