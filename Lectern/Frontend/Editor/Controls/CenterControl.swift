//
//  CenterControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct CenterControl: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(\.colorScheme) var colorScheme

    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            GeometryReader { geometry in
                Color.clear.overlay(
                    VStack(spacing: 0) {
                        HStack(spacing: 7) {
                            if vm.shipState == nil && vm.showAI == false {
                                Spacer()
                            }
                            
                            if vm.shipState != .misc && vm.shipState != .add && vm.shipState != .format {
                                SymbolButton(
                                    symbol: "rainbow",
                                    foreground: vm.showAI ? .mainColorInvert : .primary.opacity(0.9),
                                    background: vm.showAI ? .main : Color.clear
                                ) {
                                    withAnimation(.defaultSpring) {
                                        vm.showAI.toggle()
                                    }
                                }
                            }
                            
                            if vm.shipState == nil && vm.showAI == false {
                                Spacer()
                            }
                            
                            Group {
                                if vm.showAI == false {
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
                            }
                            .opacity(vm.showAI == false ? 1 : 0)
                            .blur(radius: vm.showAI == false ? 0 : 5)

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .overlay(
                            MiscControl()
                                .opacity(vm.shipState == .misc ? 1 : 0)
                                .blur(radius: vm.shipState == .misc ? 0 : 5)
                        )
                        .overlay(
                            PlaybackControl()
                                .opacity(vm.showAI ? 1 : 0)
                                .blur(radius: vm.showAI ? 0 : 5)
                        )
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
