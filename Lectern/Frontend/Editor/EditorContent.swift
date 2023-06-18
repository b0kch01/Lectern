//
//  EditorContent.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import FluidGradient

struct EditorContent: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) var colorScheme

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .overlay(
                    HStack(spacing: 0) {
                        ScrollView(showsIndicators: nvm.showNoteSwitcher ? false : true) {
                            HStack(spacing: 0) {
                                if !vm.showAI {
                                    spacer
                                }

                                Group {
                                    if sizeClass == .compact {
                                        Group {
                                            Group {
                                                if vm.showAI {
                                                    BlurtView()
                                                }
                                            }
                                            .scaleEffect(vm.showAI ? 1 : 0.9)

                                            Group {
                                                if !vm.showAI {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        RootBlockView()
                                                    }
                                                }
                                            }
                                            .scaleEffect(!vm.showAI ? 1 : 0.9)
                                        }
                                    } else {
                                        VStack(alignment: .leading, spacing: 0) {
                                            RootBlockView()
                                        }
                                    }
                                }
                                .padding(.top)
                                .padding(.horizontal, 30)
                                .padding(.bottom, geometry.size.height/2)
                                .frame(width: sizeClass == .compact ? nil : geometry.size.width/1.6)

                                spacer
                            }
                        }
                        .safeAreaPadding(.top, 120)
                        .safeAreaPadding(.bottom, 95)
                    }
                    .disabled(nvm.showNoteSwitcher)
                    .background(
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if cm.focusState == nil {
                                    if let lastRoot = cm.contentTree["root"]?.children?.last {
                                        cm.focusBlock(targetId: lastRoot)
                                    }
                                    vm.shipState = nil
                                } else {
                                    hideKeyboard()
                                }
                            }
                    )
                    .overlay(
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: geometry.size.width/1.6 + 30)

                            Group {
                                if vm.showAI && sizeClass == .regular {
                                    ScrollView(showsIndicators: nvm.showNoteSwitcher ? false : true) {
                                        BlurtView()
                                            .padding(.top)
                                            .padding(.horizontal, 30)
                                            .padding(.bottom, geometry.size.height/2)
                                    }
                                    .safeAreaPadding(.top, 120)
                                    .safeAreaPadding(.bottom, 95)
                                    .scrollPosition(initialAnchor: .bottom)
                                }
                            }
                            .scaleEffect(vm.showAI ? 1 : 0.9)
                        }
                    )
                )
        }
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(nvm.showNoteSwitcher ? 1 : 0)
                .brightness(colorScheme == .dark ? 0.15 : -0.1)
        )
        .background(
            FluidGradient(
                blobs: [
                    Color(.systemBackground).opacity(0.15),
                    Color(.systemBackground).opacity(0.5),
                    .primary.opacity(vm.showAI ? 0 : 0.3)
                ],
                highlights: [
                    colorScheme == .dark ? .black.opacity(0.9) : .white.opacity(0.5),
                    Color.yellow.opacity(vm.showAI ? (colorScheme == .dark ? 0.2 : 0.5) : 0),
                    Color.teal.opacity(vm.showAI ? (colorScheme == .dark ? 0.2 : 0.5) : 0)
                ],
                speed: 0.3,
                blur: 0.9
            )
            .background(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.9))
            .ignoresSafeArea()
        )
        .overlay(
            SafeAreaBlock(isTop: true, minimized: cm.focusState != nil || vm.shipState != nil || vm.selected != [])
            , alignment: .top
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: UIConstants.screenIsRounded ?
                UIConstants.screenRadius : (nvm.showNoteSwitcher ? UIConstants.screenRadius : 0),
                style: .continuous
            )
        )
        .shadow(color: Color.black.opacity(nvm.showNoteSwitcher ? 1 : 0), radius: 30, y: 0)
    }

    private var spacer: some View {
        Group {
            if sizeClass == .regular {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                        withAnimation(.defaultSpring) {
                            vm.selected = []
                            vm.shipState = nil
                        }
                    }
            }
        }
    }
}
