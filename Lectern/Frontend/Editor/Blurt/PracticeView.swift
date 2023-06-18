//
//  PracticeView.swift
//  Lectern
//
//  Created by Nathan Choi on 6/18/23.
//

import SwiftUI
import WrappingHStack

struct PracticeView: View {

    @Environment(ContentManager.self) var cm

    @State var blurtVM = BlurtViewModel()

    var allText: [String] {
        blurtVM.savedText + blurtVM.mainText
    }

    @ViewBuilder
    var body: some View {
        ForEach(cm.questions) { question in
            if question.role == "assistant" {
                Text(question.content)
                    .foregroundColor(.red)
            } else {
                Text(question.content)
                    .foregroundStyle(.blue)
            }
        }

        WrappingHStack(allText.indices, id:\.self, spacing: .constant(0), lineSpacing: 7) { i in
            Text(allText[i] + " ")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary.opacity(i == allText.count - 1 ? (cm.study.count == 0 ? 1 : 0.5) : 0.5))
                .opacity(cm.study.count == 0 ? 1 : 0.2)
                .animation(.spring, value: allText)
                .id(i)
        }
            .onChange(of: cm.sr.transcript) {
                blurtVM.mainText = cm.sr.transcript.components(separatedBy: " ")
            }
            .onAppear {
                cm.blurtPracticeVM = blurtVM
                cm.sr.stopTranscribing()
                cm.studyState = .practicingPaused
            }
    }
}
