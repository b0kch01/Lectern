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

                                VStack(alignment: .leading, spacing: 0) {
                                    RootBlockView()
                                }
                                .padding(.top)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30)
                                .frame(width: sizeClass == .compact ? nil : geometry.size.width/1.6)

                                spacer
                            }
                        }
                        .safeAreaPadding(.top, 120)
                        .safeAreaPadding(.bottom, 95)
                        .safeAreaPadding(.bottom, sizeClass == .compact ? (vm.showAI ? Screen.width : 0) : 0)
                    }
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
                                        BlurtView(headerBlockId: "1")
                                            .padding(.top)
                                            .padding(.horizontal, 30)
                                            .padding(.bottom, 30)
                                    }
                                    .safeAreaPadding(.top, 120)
                                    .safeAreaPadding(.bottom, 95)
                                    .scrollPosition(initialAnchor: .bottom)
                                }
                            }
                            .scaleEffect(vm.showAI ? 1 : 0.9)
                        }
                    )
                    .overlay(
                        VStack(spacing: 0) {
                            if vm.showAI && sizeClass == .compact {
                                ZStack(alignment: .top) {
                                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                        .frame(
                                            width: 9999,
                                            height: Screen.height/2 + 80
                                        )
                                        .padding(.horizontal, -200)
                                        .blur(radius: 20)
                                        .contrast(colorScheme == .dark ? 1.1 : 1)

                                    Bar(color: Color(.secondarySystemFill))
                                        .padding(.horizontal, 30)
                                        .offset(y: 40)
                                        .frame(width: Screen.width)

                                    ScrollView(showsIndicators: nvm.showNoteSwitcher ? false : true) {
                                        BlurtView(headerBlockId: "1")
                                            .padding(.horizontal, 30)
                                            .padding(.top, 80)
                                    }
                                    .frame(width: Screen.width)
                                    .mask(LinearGradient(gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0.1),
                                        .init(color: .black, location: 0.2)
                                    ]), startPoint: .top, endPoint: .bottom))
                                }
                            }

                            Spacer()
                        }
                        .frame(width: Screen.width, height: Screen.height/2 + 80)
                        , alignment: .bottom
                    )
                    .disabled(nvm.showNoteSwitcher)
                )
        }
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(nvm.showNoteSwitcher ? 1 : 0)
                .brightness(colorScheme == .dark ? 0.15 : -0.15)
        )
        .background(
            FluidGradient(
                blobs: [
                    Color(.systemBackground).opacity(0.1),
                    .primary.opacity(vm.showAI ? 0 : (colorScheme == .dark ? 0.1 : 0.25))
                ],
                highlights: [
                    colorScheme == .dark ? .black.opacity(0.15) : .white.opacity(0.15),
                    Color.yellow.opacity(vm.showAI ? (colorScheme == .dark ? 0.1 : 0.2) : 0),
                    Color.cyan.opacity(vm.showAI ? (colorScheme == .dark ? 0.1 : 0.2) : 0)
                ],
                speed: 0.3,
                blur: 0.7
            )
            .background(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.9))
            .ignoresSafeArea()
            .animation(.smooth(duration: 0.7), value: vm.showAI)
        )
        .overlay(
            SafeAreaBlock(isTop: true, minimized: cm.focusState != nil || vm.shipState != nil || vm.selected != [])
            , alignment: .top
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    nvm.roundCorners ? (UIConstants.screenIsRounded ? UIConstants.screenRadius : UIConstants.screenRadius) : 0,
                style: .continuous
            )
        )
        .shadow(color: Color.black.opacity(nvm.roundCorners ? (nvm.showNoteSwitcher ? 1 : 0) : 0), radius: 30, y: 0)
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
                    .disabled(vm.showAI)
            }
        }
    }
}
