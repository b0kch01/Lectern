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


@Observable
class BlurtViewModel {
    var savedText = [String]()
    var mainText = [String]()
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
            Text("Test text placeholder")
                .font(.title3.weight(.semibold))
            Text("Test text placeholder")
                .font(.title3.weight(.semibold))
            Text("Test text placeholder")
                .font(.title3.weight(.semibold))
            Text("Test text placeholder")
                .font(.title3.weight(.semibold))
            Text("Test text placeholder")
                .font(.title3.weight(.semibold))


            Divider()
            Text(allText.last ?? "")
            Divider()
                .onChange(of: cm.sr.transcript) {
                    print("CHANGIN")
                    blurtVM.mainText = $0.components(separatedBy: " ")
                }

//            WrappingHStack(allText.indices, id:\.self, spacing: .constant(0), lineSpacing: 7) { i in
//                Text(allText[i] + " ")
//                    .font(.title3.weight(.semibold))
//                    .foregroundStyle(.primary.opacity(i == allText.count - 1 ? 1 : 0.5))
//                    .animation(.spring, value: allText)
//                    .id(i)
//            }
//            .onChange(of: cm.sr.transcript) {
//                blurtVM.mainText = cm.sr.transcript.components(separatedBy: " ")
//            }
            .animation(.spring, value: cm.sr.transcript)

//            HStack(spacing: 10) {
//                Image(systemName: "exclamationmark.triangle.fill")
//                    .font(.body.weight(.semibold))
//                    .foregroundStyle(.mainColorInvert)
//                    .frame(width: 21, height: 21)
//
//                VerticalBar(color: Color(.secondarySystemFill), height: 19)
//
//                Text("39")
//                    .font(.callout.weight(.medium))
//                    .font(.system(size: UIConstants.callout, design: .rounded).weight(.medium))
//                    .foregroundStyle(.mainColorInvert)
//                    .frame(width: 21, height: 21)
//            }
//            .padding(.horizontal, 2)
//            .padding(7)
//            .background(.yellow)
//            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
//            .contentShape(Rectangle())

//            HStack(spacing: 10) {
//                if cm.studyState == .transcribingPaused {
//                    Button(action: {
//                        withAnimation(.snappy) {
//                            cm.sr.startTranscribing()
//                            cm.studyState = .transcribing
//                        }
//                    }) {
//                        Image(systemName: "mic.slash.fill")
//                            .font(.body.weight(.semibold))
//                            .foregroundStyle(.primary.opacity(0.9))
//                            .frame(width: 21, height: 21)
//                            .contentShape(Rectangle())
//                    }
//
//                    VerticalBar(color: Color(.secondarySystemFill), height: 19)
//
//                    if cm.studyState == .blurting {
//                        ProgressView()
//                    } else {
//                        Button(action: {
//                            cm.blurt()
//                        }) {
//                            Image(systemName: "checkmark")
//                                .font(.callout.weight(.medium))
//                                .foregroundStyle(.primary.opacity(0.9))
//                                .frame(width: 21, height: 21)
//                                .contentShape(Rectangle())
//                        }
//                    }
//                } else {
//                    Image(systemName: "waveform")
//                        .font(.title3.weight(.semibold))
//                        .foregroundStyle(.mainColorInvert)
//                        .symbolEffect(.pulse)
//                        .symbolEffect(.bounce, value: bounced)
//                        .frame(width: 21, height: 21)
////                        .onTapGesture {
////                            print("STOPPED RECORDING")
////                            withAnimation(.snappy) {
////                                cm.studyState = .transcribingPaused
////                                blurtVM.savedText += blurtVM.mainText
////                                cm.sr.stopTranscribing()
////                            }
////                        }
//
//                }
//            }
//            .padding(.horizontal, cm.studyState == .transcribingPaused ? 2 : 0)
//            .padding(7)
//            .background(cm.studyState == .transcribingPaused ? Color(.tertiarySystemFill) : .main)
//            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
//            .contentShape(Rectangle())
//            .hoverEffect(.highlight)
//            .padding(.top, 10)


//            Image(systemName: "arrow.counterclockwise")
//                .font(.body.weight(.semibold))
//                .foregroundStyle(.mainColorInvert)
//                .frame(width: 21, height: 21)
//                .padding(7)
//                .background(cm.studyState == .transcribingPaused ? Color(.tertiarySystemFill) : .main)
//                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
//                .contentShape(Rectangle())
//                .hoverEffect(.highlight)
//                .padding(.top, 10)


            Spacer()
        }
        .padding(.top)
        .padding(.trailing, 30)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
        .task {
            print("STARTING RECORDING")
            cm.blurtVM = blurtVM
            cm.sr.resetTranscript()
            cm.sr.startTranscribing()
        }
    }
}
