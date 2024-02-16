//
//  NavigationBar.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct NavigationBar: View {

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @State var noteTitle: String = "SampleNote.pdf"

    @State var showFlashcard = false

    var title: String
    var minimized: Bool

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(.quaternaryLabel))
                .frame(width: 35, height: 4.3)
                .padding(.top, 7)

            HStack(spacing: 0) {
                TextField(
                    "Untitled Note",
                    text: $noteTitle
                )
                .font(Font.custom("OpenRunde-Semibold", size: 16))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .submitLabel(.done)

                Image(systemName: "chevron.down")
                    .font(.footnote.weight(.bold))
                    .offset(y: 1)
                    .padding(.leading, 7)

                Spacer()

                Button(action: {
                    if !nvm.roundCorners {
                        withAnimation(.linear(duration: 0), completionCriteria: .logicallyComplete) {
                            nvm.roundCorners = true
                        } completion: {
                            LightHaptics.shared.play(.soft)

                            withAnimation(.smooth(duration: 0.3)) {
                                nvm.showNoteSwitcher = true
                                vm.selected = []
                                vm.shipState = nil
                            }
                        }
                    }
                }) {
                    Image(systemName: "square.on.square")
                        .font(.system(size: 20))
                        .padding(9)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                        .contentShape(Rectangle())
                        .hoverEffect(.highlight)
                }
                .padding(-9)
            }
            .padding(.vertical)
            .padding(.horizontal)
            .foregroundStyle(.primary.opacity(0.9))
            .opacity(minimized ? 0 : 1)
            .overlay(
                checkMarkButton
                    .animation(.smooth) { content in
                        content
                            .blur(radius: minimized ? 0 : 20)
                    }
                , alignment: .trailing
            )

            Spacer()
        }
    }

    private var checkMarkButton: some View {
        Group {
            if minimized {
                Button(action: {
                    hideKeyboard()
                    withAnimation(.defaultSpring) {
                        vm.selected = []
                        vm.shipState = nil
                        cm.focusState = nil
                    }
                }) {
                    RoundedButton(symbol: "checkmark")
                        .padding()
                        .contentShape(Rectangle())
                        .hoverEffect(.lift)
                }
                .transition(.scale)
            }
        }
    }
}
