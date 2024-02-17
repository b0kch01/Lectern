//
//  ImportControl.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI

struct ImportControl: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(\.colorScheme) var colorScheme

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            GeometryReader { geometry in
                Color.clear.overlay(
                    VStack(spacing: 0) {
                        HStack(spacing: 7) {
                            if !vm.showFile && !vm.showScan {
                                Spacer()
                            }

                            if !vm.showScan {
                                SymbolButton(
                                    symbol: "folder.badge.plus",
                                    foreground: vm.showFile ? .mainColorInvert : .primary.opacity(0.9),
                                    background: vm.showFile ? .main : Color.clear
                                ) {
                                    withAnimation(.defaultSpring) {
                                        vm.showFile.toggle()
                                        vm.showScan = false
                                    }
                                }
                            }

                            if !vm.showFile && !vm.showScan {
                                Spacer()
                            }

                            if !vm.showFile {
                                SymbolButton(
                                    symbol: "doc.viewfinder",
                                    foreground: vm.showScan ? .mainColorInvert : .primary.opacity(0.9),
                                    background: vm.showScan ? .main : Color.clear
                                ) {
                                    withAnimation(.defaultSpring) {
                                        vm.showScan.toggle()
                                        vm.showFile = false
                                    }
                                }
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .foregroundStyle(.primary.opacity(0.9))
                        .padding(.top, 9)
                        .padding(.bottom, 16)
                    }
                    .frame(width: sizeClass == .compact ? geometry.size.width : geometry.size.width/1.6)
                    , alignment: .bottom
                )
            }
            .frame(height: 74)
            .padding(.bottom, safeAreaInsets.bottom)
            .background(SafeAreaBlockBottom().ignoresSafeArea())
        }
    }
}
