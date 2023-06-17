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
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            WrappingHStack(mainText.indices, id:\.self, spacing: .constant(0), lineSpacing: 5) { i in
                BlurtTextView(word: mainText[i])
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary.opacity(i == mainText.count - 1 ? 1 : 0.5))
                    .animation(.spring, value: mainText)
                    .id(i)
            }
            .onChange(of: sr.transcript) {
                mainText = sr.transcript.components(separatedBy: " ")
            }
            .transition(.scale)
            .animation(.spring, value: sr.transcript)

            Image(systemName: "waveform")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .symbolEffect(.pulse)
                .symbolEffect(.bounce, value: bounced)
                .opacity(0.9)
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
