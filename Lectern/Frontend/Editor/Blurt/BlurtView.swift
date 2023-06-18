//
//  BlurtView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import WrappingHStack
import Speech


@Observable
class BlurtViewModel {
    @State var savedText = [String]()
    @State var mainText = [String]()
}

struct BlurtView: View {

    @Environment(ContentManager.self) var cm

    var blurtVM = BlurtViewModel()



    // Symbol Animation
    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()



    var allText: [String] {
        blurtVM.savedText + blurtVM.mainText
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
//            Text("Test text placeholder")
//                .font(.title3.weight(.semibold))
//            Text("Test text placeholder")
//                .font(.title3.weight(.semibold))
//            Text("Test text placeholder")
//                .font(.title3.weight(.semibold))
//            Text("Test text placeholder")
//                .font(.title3.weight(.semibold))
//            Text("Test text placeholder")
//                .font(.title3.weight(.semibold))
//            
            WrappingHStack(allText.indices, id:\.self, spacing: .constant(0), lineSpacing: 7) { i in
                Text(allText[i] + " ")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary.opacity(i == allText.count - 1 ? 1 : 0.5))
                    .animation(.spring, value: allText)
                    .id(i)
            }
            .onChange(of: cm.sr.transcript) {
                mainText = cm.sr.transcript.components(separatedBy: " ")
            }
            .animation(.spring, value: cm.sr.transcript)

            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.mainColorInvert)
                    .frame(width: 21, height: 21)

                VerticalBar(color: Color(.secondarySystemFill), height: 19)

                Text("39")
                    .font(.callout.weight(.medium))
                    .font(.system(size: UIConstants.callout, design: .rounded).weight(.medium))
                    .foregroundStyle(.mainColorInvert)
                    .frame(width: 21, height: 21)
            }
            .padding(.horizontal, 2)
            .padding(7)
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            .contentShape(Rectangle())

            Button(action: {
                withAnimation(.snappy) {
                    pauseTranscribe.toggle()
                }

                if pauseTranscribe {
                    cm.sr.stopTranscribing()
                } else {
                    cm.sr.startTranscribing()
                }
            }) {
                Group {
                    if pauseTranscribe {
                        HStack(spacing: 10) {
                            Image(systemName: "mic.slash.fill")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.9))
                                .frame(width: 21, height: 21)

                            VerticalBar(color: Color(.secondarySystemFill), height: 19)

                            Image(systemName: "checkmark")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.primary.opacity(0.9))
                                .frame(width: 21, height: 21)
                        }
                    } else {
                        Image(systemName: "waveform")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.mainColorInvert)
                            .symbolEffect(.pulse)
                            .symbolEffect(.bounce, value: bounced)
                            .frame(width: 21, height: 21)
                    }
                }
                .padding(.horizontal, pauseTranscribe ? 2 : 0)
                .padding(7)
                .background(pauseTranscribe ? Color(.tertiarySystemFill) : .main)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .contentShape(Rectangle())
                .hoverEffect(.highlight)
            }
            .padding(.top, 10)

            Image(systemName: "arrow.counterclockwise")
                .font(.body.weight(.semibold))
                .foregroundStyle(.mainColorInvert)
                .frame(width: 21, height: 21)
                .padding(7)
                .background(pauseTranscribe ? Color(.tertiarySystemFill) : .main)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .contentShape(Rectangle())
                .hoverEffect(.highlight)
                .padding(.top, 10)

            Capsule()
                .frame(height: 5)
                .padding(.top, 10)

            Spacer()
        }
        .padding(.top)
        .padding(.trailing, 30)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
        .task {
            cm.blurtVM = blurtVM
            cm.sr.resetTranscript()
            cm.sr.startTranscribing()
        }
    }
}
