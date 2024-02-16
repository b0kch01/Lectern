////
////  EditorContent.swift
////  Lectern
////
////  Created by Paul Wong on 6/17/23.
////
//
//import SwiftUI
//import FluidGradient
//
//struct EditorContent: View {
//
//    @Environment(\.horizontalSizeClass) var sizeClass
//    @Environment(\.colorScheme) var colorScheme
//
//    @Environment(ContentManager.self) var cm
//    @Environment(EditorViewModel.self) var vm
//    @Environment(NavigationViewModel.self) var nvm
//
//    var body: some View {
//        GeometryReader { geometry in
//            Color.clear
//                .overlay(
//                    HStack(spacing: 0) {
//                        ScrollView(showsIndicators: vm.showNoteSwitcher ? false : true) {
//                            HStack(spacing: 0) {
//                                if !vm.showAI {
//                                    spacer
//                                }
//
//                                Group {
//                                    if vm.showAI && sizeClass == .compact {
//                                        BlurtView(headerBlockId: "1")
//                                    } else {
//                                        VStack(alignment: .leading, spacing: 0) {
//                                            RootBlockView()
//                                        }
//                                    }
//                                }
//                                .padding(24)
//                                .frame(width: sizeClass == .compact ? nil : geometry.size.width/1.6)
//
//                                spacer
//                            }
//                            .padding(.top, (vm.shipState == nil && cm.focusState == nil) ? 120 : 90)
//                            .padding(.bottom, sizeClass == .compact ? (vm.showAI ? Screen.width : 0) : 0)
//                        }
//                        .safeAreaPadding(.bottom, 74)
//                    }
//                    .background(backgroundContentShape)
//                    .overlay(
//                        HStack(spacing: 0) {
//                            Spacer()
//                                .frame(width: geometry.size.width/1.6 + 30)
//
//                            Group {
//                                if vm.showAI && sizeClass == .regular {
//                                    ScrollView(showsIndicators: nvm.showNoteSwitcher ? false : true) {
//                                        BlurtView(headerBlockId: "1")
//                                            .padding(.top)
//                                            .padding(.horizontal, 24)
//                                            .padding(.bottom, 24)
//                                    }
//                                    .safeAreaPadding(.top, 120)
//                                    .safeAreaPadding(.bottom, 95)
//                                    .scrollPosition(initialAnchor: .bottom)
//                                }
//                            }
//                            .scaleEffect(vm.showAI ? 1 : 0.9)
//                        }
//                    )
//                    .disabled(nvm.showNoteSwitcher)
//                )
//        }
//        .background(
//            FluidGradient(
//                blobs: [
//                    Color.elevatedBackground.opacity(0)
//                ],
//                highlights: [
//                    Color.yellow.opacity(colorScheme == .dark ? 0.1 : 0.2)
//                ],
//                speed: 0.3,
//                blur: 0.7
//            )
//            .background(Color.elevatedBackground)
//            .ignoresSafeArea()
//            .animation(.smooth(duration: 0.7), value: vm.showAI)
//            .opacity(vm.showAI ? 1 : 0)
//        )
//        .background(
//            Color.elevatedBackground
//                .ignoresSafeArea()
//        )
//        .overlay(
//            SafeAreaBlockTop(minimized: cm.focusState != nil || vm.shipState != nil || vm.selected != [])
//            , alignment: .top
//        )
//        .clipShape(
//            RoundedRectangle(
//                cornerRadius:
//                    nvm.roundCorners ? (UIConstants.screenIsRounded ? UIConstants.screenRadius : UIConstants.screenRadius) : 0,
//                style: .continuous
//            )
//        )
//        .shadow(color: Color.black.opacity(nvm.roundCorners ? (nvm.showNoteSwitcher ? 1 : 0) : 0), radius: 30, y: 0)
//    }
//
//    private var spacer: some View {
//        Group {
//            if sizeClass == .regular {
//                Color.clear
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        hideKeyboard()
//                        withAnimation(.defaultSpring) {
//                            vm.selected = []
//                            vm.shipState = nil
//                        }
//                    }
//                    .disabled(vm.showAI)
//            }
//        }
//    }
//
//    private var backgroundContentShape: some View {
//        Color.clear
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if cm.focusState == nil {
//                    if let lastRoot = cm.contentTree["root"]?.children?.last {
//                        cm.focusBlock(targetId: lastRoot)
//                    }
//                    vm.shipState = nil
//                } else {
//                    hideKeyboard()
//                }
//            }
//    }
//}
