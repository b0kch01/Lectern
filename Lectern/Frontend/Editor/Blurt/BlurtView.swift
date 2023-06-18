//
//  BlurtView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import WrappingHStack
import Speech

struct BlurtView: View {

    @State private var directoryAccessError: Error?

    @State var nvm = NavigationViewModel()
    @State var sr = SpeechRecognizer()

    @State var mainText = [String]()
    @State var bounced = true
    @State var pauseTranscribe = false
    @State var show = false

    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            WrappingHStack(mainText.indices, id:\.self, spacing: .constant(0), lineSpacing: 5) { i in
                Text(mainText[i] + " ")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary.opacity(i == mainText.count - 1 ? 1 : 0.5))
                    .animation(.spring, value: mainText)
                    .id(i)
                    .onAppear {
                        show.toggle()
                    }
            }
            .onChange(of: sr.transcript) {
                mainText = sr.transcript.components(separatedBy: " ")
            }
            .animation(.spring, value: sr.transcript)

            Button(action: {
                withAnimation(.snappy) {
                    pauseTranscribe.toggle()
                }
            }) {
                Group {
                    if pauseTranscribe {
                        Image(systemName: "mic.slash.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.9))
                    } else {
                        Image(systemName: "waveform")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.mainColorInvert)
                            .symbolEffect(.pulse)
                            .symbolEffect(.bounce, value: bounced)
                    }
                }
                .frame(width: 21, height: 21)
                .padding(9)
                .background(pauseTranscribe ? Color(.tertiarySystemFill) : .main)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .contentShape(Rectangle())
                .hoverEffect(.highlight)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding(.top)
        .padding(.trailing, 30)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
        .task {
            sr.resetTranscript()
            try? await Task.sleep(nanoseconds: 500_000_000)

            sr.startTranscribing()
        }
    }
}
