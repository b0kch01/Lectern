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
    @State var importPDF = false

    var title: String
    var minimized: Bool

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(.quaternaryLabel))
                .frame(width: 35, height: 4.3)
                .padding(.vertical, 7)

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
            }
            .padding(.vertical)
            .padding(.horizontal)
            .foregroundStyle(.primary.opacity(0.9))
            .opacity(minimized && nvm.selectedPage != .miscView ? 0 : 1)
            .blur(radius: minimized && nvm.selectedPage != .miscView ? 10 : 0)
            .overlay(
                ZStack {
                    checkMarkButton
                        .blur(radius: minimized || vm.showAI ? 0 : 20)
                        .opacity(minimized || vm.showAI ? 1 : 0)
                        .animation(.smooth(duration: 0.3), value: minimized || vm.showAI)

                    addButton
                        .blur(radius: !minimized && !vm.showAI ? 0 : 20)
                        .opacity(!minimized && !vm.showAI ? 1 : 0)
                        .animation(.smooth(duration: 0.3), value: minimized || vm.showAI)
                }
                , alignment: .trailing
            )

            Spacer()
        }
    }

    private var checkMarkButton: some View {
        Group {
            if minimized || vm.showAI {
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
                .transformEffect(.identity)
            }
        }
    }

    var addButton: some View {
        Group {
            if !minimized && !vm.showAI {
                Button(action: {
                    withAnimation(.smooth(duration: 0.2)) {
                        vm.importPDF = true
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: UIConstants.subhead).weight(.semibold))
                        .foregroundStyle(.main)
                        .padding(.vertical, 9)
                        .padding(.horizontal, 24)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 39, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 39, style: .continuous)
                                .stroke(.borderBackground, lineWidth: 1)
                        )
                        .padding()
                        .contentShape(Rectangle())
                        .hoverEffect(.lift)
                        .transition(.scale)
                        .transformEffect(.identity)
                }
            }
        }
    }
}
