//
//  CenterControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct CenterControl: View {

    @Environment(\.horizontalSizeClass) var sizeClass

    @Environment(\.colorScheme) var colorScheme

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if vm.showAI && sizeClass == .compact {
                LeadingHStack {
                    Text("Why is active recall so powerful?")
                        .font(.system(size: UIConstants.body).weight(.semibold))
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 11)
                .background(Color.highlightYellow)
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(.yellow, lineWidth: 2)
                )
                .padding(.bottom, 16)
                .padding(.horizontal, 24)
            }

            Bar(color: Color(.secondarySystemFill))
                .padding(.horizontal, 24)

            HStack(spacing: 7) {
                if vm.shipState == nil {
                    Spacer()
                }

                if vm.shipState != .misc && vm.shipState != .add {
                    SymbolButton(
                        symbol: "studentdesk",
                        foreground: vm.shipState == .study ? .mainColorInvert : .primary.opacity(0.9),
                        background: vm.shipState == .study ? .main : Color.clear
                    ) {
                        withAnimation(.defaultSpring) {
                            if vm.shipState == nil {
                                vm.shipState = .study
                            } else {
                                vm.shipState = nil
                            }
                        }
                    }
                }

                if vm.shipState == nil {
                    Spacer()
                }

                if vm.shipState != .misc && vm.shipState != .study {
                    SymbolButton(
                        symbol: "plus",
                        foreground: vm.shipState == .add ? .mainColorInvert : .primary.opacity(0.9),
                        background: vm.shipState == .add ? .main : Color.clear
                    ) {
                        withAnimation(.defaultSpring) {
                            if vm.shipState == nil {
                                vm.shipState = .add
                            } else {
                                vm.shipState = nil
                            }
                        }
                    }
                }

                if vm.shipState == nil {
                    Spacer()
                }

                if vm.shipState != .misc && vm.shipState != .study {
                    SymbolButton(
                        symbol: "textformat",
                        foreground: vm.shipState == .format ? .mainColorInvert : .primary.opacity(0.9),
                        background: vm.shipState == .format ? .main : Color.clear
                    ) {
                        withAnimation(.defaultSpring) {
                            if vm.shipState == nil {
                                vm.shipState = .format
                            } else {
                                vm.shipState = nil
                            }
                        }
                    }
                }

                if vm.shipState == nil {
                    Spacer()
                }

                if vm.shipState != .study && vm.shipState != .add {
                    SymbolButton(
                        symbol: "ellipsis",
                        foreground: vm.shipState == .misc ? .mainColorInvert : .primary.opacity(0.9),
                        background: vm.shipState == .misc ? .main : Color.clear
                    ) {
                        withAnimation(.defaultSpring) {
                            if vm.shipState == nil {
                                vm.shipState = .misc
                            } else {
                                vm.shipState = nil
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .overlay(
                StudyControl()
                    .opacity(vm.shipState == .study ? 1 : 0)
            )
            .overlay(
                AddControl()
                    .opacity(vm.shipState == .add ? 1 : 0)
            )
            .overlay(
                MiscControl()
                    .opacity(vm.shipState == .misc ? 1 : 0)
            )
            .overlay(
                PlaybackControl()
                    .opacity(vm.showAI ? 1 : 0)
            )
            .foregroundStyle(.primary.opacity(0.9))
            .padding(.top, 9)
            .padding(.bottom, 16)
        }
    }
}
