//
//  BlurtView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation
import WrappingHStack
import Speech
import FluidGradient

@Observable
class BlurtViewModel {
    var savedText = [String]()
    var mainText = [""]

    var selectedBlock = ""
}

struct BlurtView: View {

    @Environment(\.horizontalSizeClass) var sizeClass

    @Environment(ContentManager.self) var cm

    @State var blurtVM = BlurtViewModel()
    @State var isBlurting = false

    var headerBlockId: String

    // Symbol Animation
    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()


    var allText: [String] {
        blurtVM.savedText + blurtVM.mainText
    }

    var feedback: [String] {
        Array(cm.study.keys)
            .filter { !$0.hasPrefix("q__") }
            .sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !isBlurting {
                Text("To start blurting, tap here to start typing or tap \(Image(systemName: "mic.slash.fill")) to start dictating.\n\nTap \(Image(systemName: "backward.fill")) or \(Image(systemName: "forward.fill")) to skip topics.")
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
                                Color.yellow.opacity(0.7),
                                Color.cyan.opacity(0.7)
                            ],
                            speed: 0.7,
                            blur: 0.9
                        )
                        .mask(
                            Text("To start blurting, tap here to start typing or tap \(Image(systemName: "mic.slash.fill")) to start dictating.\n\nTap \(Image(systemName: "backward.fill")) or \(Image(systemName: "forward.fill")) to skip topics.")
                                .font(.title3.weight(.semibold))
                                .lineSpacing(7)
                                .multilineTextAlignment(.trailing)
                        )
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
                withAnimation(.spring) { isBlurting = true }

                if cm.studyState != .practicing {
                    blurtVM.mainText = cm.sr.transcript.components(separatedBy: " ")
                }
            }
            .animation(.spring, value: cm.sr.transcript)

            ForEach(feedback, id:\.self) { key in
                if let feedback = cm.study[key]?.feedback {
                    Button(action: {
                        cm.studySelect = key
                    }) {
                        HStack(spacing: 0) {
                            Spacer()

                            Text(feedback)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.gray)
                                .animation(.spring, value: allText)
                                .multilineTextAlignment(.trailing)
                                .id(key)
                                .overlay {
                                    FluidGradient(
                                        blobs: [
                                            Color(.systemBackground).opacity(0.3),
                                            Color(.systemBackground).opacity(0.9)
                                        ],
                                        highlights: [
                                            .white.opacity(0.5),
                                            Color.yellow.opacity(0.5),
                                            Color.cyan.opacity(0.5)
                                        ],
                                        speed: 0.7,
                                        blur: 0.9
                                    )
                                    .mask(
                                        Text(feedback)
                                            .font(.title3.weight(.semibold))
                                            .animation(.spring, value: allText)
                                            .multilineTextAlignment(.trailing)
                                            .id(key)
                                    )
                                }
                                .padding(11)
                                .scaleEffect(cm.studySelect == key ? 0.95 : 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color(.quaternarySystemFill).opacity(cm.studySelect == key ? 1 : 0))
                                )
                                .padding(.leading, 60)
                        }
                    }
                }
            }

            if feedback.count != 0 {
                VStack(spacing: 20) {
                    Bar(color: Color(.secondarySystemFill))

                    Text("Tap \(Image(systemName: "arrow.counterclockwise")) to try again, or tap \(Image(systemName: "backward.fill")) or \(Image(systemName: "forward.fill")) to skip topics.")
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
                                    Color.yellow.opacity(0.7),
                                    Color.cyan.opacity(0.7)
                                ],
                                speed: 0.7,
                                blur: 0.9
                            )
                            .mask(
                                Text("Tap \(Image(systemName: "arrow.counterclockwise")) to try again, or tap \(Image(systemName: "backward.fill")) or \(Image(systemName: "forward.fill")) to skip topics.")
                                    .font(.title3.weight(.semibold))
                                    .lineSpacing(7)
                                    .multilineTextAlignment(.trailing)
                            )
                        }
                        .onTapGesture {
                            cm.practice()
                        }
                }

//                Divider()

//                PracticeView()
//                    .onAppear {
//                        print("Initializing practice!")
//                        cm.practice()
//                    }
            }

        }
        .padding(.top)
        .padding(.trailing, sizeClass == .regular ? 30 : 0)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
        .onAppear {
            cm.studySelect = headerBlockId
            cm.blurtViewVM = blurtVM
            cm.studyState = .transcribingPaused
        }
    }
}
