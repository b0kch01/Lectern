//
//  PracticeView.swift
//  Lectern
//
//  Created by Nathan Choi on 6/18/23.
//

import SwiftUI
import WrappingHStack
import FluidGradient

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
                Button(action: {
                    cm.practiceSelect = question.content
                    cm.sr.startTranscribing()
                    cm.studyState = .practicing
                }) {
                    HStack(spacing: 0) {
                        Spacer()

                        Text(question.content)
                            .font(.title3.weight(.semibold))
                            .lineSpacing(7)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.trailing)
                            .overlay {
                                FluidGradient(
                                    blobs: [
                                        Color(.systemBackground).opacity(0.3),
                                        Color(.systemBackground).opacity(0.9)
                                    ],
                                    highlights: [
                                        .white.opacity(0.5),
                                        Color.yellow.opacity(0.7)
                                    ],
                                    speed: 0.7,
                                    blur: 0.9
                                )
                                .mask(
                                    Text(question.content)
                                        .font(.title3.weight(.semibold))
                                        .lineSpacing(7)
                                        .multilineTextAlignment(.trailing)
                                )
                            }
                            .padding(11)
                            .scaleEffect(cm.practiceSelect == question.content ? 0.95 : 1)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(Color(.quaternarySystemFill).opacity(cm.practiceSelect == question.content ? 1 : 0))
                            )
                            .padding(.leading, 60)
                    }
                }
            } else {
                Text(question.content)
                    .font(.title3.weight(.semibold))
                    .lineSpacing(7)
                    .foregroundStyle(.main)
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
