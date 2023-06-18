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


    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            if !isBlurting {
                Text("Super star \(Image(systemName: "mic.slash.fill"))")
                    .font(.title3.weight(.semibold))
            }

            WrappingHStack(allText.indices, id:\.self, spacing: .constant(0), lineSpacing: 7) { i in
                Text(allText[i] + " ")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary.opacity(i == allText.count - 1 ? 1 : 0.5))
                    .animation(.spring, value: allText)
                    .id(i)
            }
            .onChange(of: cm.sr.transcript) {
                withAnimation(.spring) { isBlurting = true }
                blurtVM.mainText = cm.sr.transcript.components(separatedBy: " ")
            }
            .animation(.spring, value: cm.sr.transcript)


            ForEach(Array(cm.study.keys).sorted(), id:\.self) { key in
                if let feedback = cm.study[key]?.feedback {
                    Button(action: {
                        cm.studySelect = key
                    }) {
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: 40)

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
                                            Color.pink.opacity(0.5)
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
                                .padding(.leading, 50)
                        }
                    }
                }
            }
        }
        .padding(.top)
        .padding(.trailing, 30)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
        .onAppear {
            cm.studySelect = headerBlockId
            cm.blurtVM = blurtVM
            cm.studyState = .transcribingPaused
        }
    }
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {
            FluidGradient(
                blobs: [
                    Color(.systemBackground).opacity(0.15),
                    Color(.systemBackground).opacity(0.5)
                ],
                highlights: [
                    .white.opacity(0.5),
                    Color.yellow.opacity(0.5),
                    Color.teal.opacity(0.5)
                ],
                speed: 0.3,
                blur: 0.9
            )
            .mask(
                self

            )
        }
    }
}
