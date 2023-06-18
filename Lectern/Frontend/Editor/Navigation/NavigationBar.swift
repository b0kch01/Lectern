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

    @State var noteTitle: String = "Getting Started on Lectern"

    @State var showFlashcard = false

    var title: String
    var minimized: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
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
                }) {
                    Image(systemName: "square.on.square")
                        .font(.system(size: 20))
                        .padding(20)
                        .contentShape(Rectangle())
                }
                .padding(-20)

                CenterHStack {
                    TextField(
                        "Untitled Note",
                        text: $noteTitle
                    )
                    .font(.system(size: UIConstants.callout).weight(.semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal)
                    .submitLabel(.done)
                }

//                Button(action: {
//                    showFlashcard = true
//                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .padding(20)
                        .contentShape(Rectangle())
                        .padding(-20)
                        .opacity(0) //
//                }
//                .sheet(isPresented: $showFlashcard) {
//                    Flashcard(text: "Placeholder")
//                        .presentationBackground(.clear)
//                        .presentationDetents([.medium])
//                        .ignoresSafeArea()
//                }
            }
            .padding(.vertical)
            .padding(.horizontal, 30)
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
                }
                .transition(.scale)
            }
        }
    }
}
