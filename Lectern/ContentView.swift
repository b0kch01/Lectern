//
//  ContentView.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

struct ContentView: View {

    @State var nvm = NavigationViewModel()
    @State var sr = SpeechRecognizer()

    @State var mainText = [String]()

    var body: some View {
//        ParentView()
        HStack(spacing: 5) {
            ForEach(mainText.indices, id:\.self) { i in
                LecternTextReveal(word: mainText[i])
                    .animation(.spring)
                    .id(i)
            }
        }
        .onChange(of: sr.transcript) {
            mainText = sr.transcript.components(separatedBy: " ")
        }
                .transition(.scale)
                .animation(.spring, value: sr.transcript)
                .environment(nvm)
                .task {
                    print("STARTIN SCRIPT")
                    sr.resetTranscript()
                    sr.startTranscribing()

                    //try? await Task.sleep(nanoseconds: 5_000_000_000)
                    //sr.stopTranscribing()
                    //print(sr.transcript)
                }
    }
}

#Preview {
    ContentView()
}
