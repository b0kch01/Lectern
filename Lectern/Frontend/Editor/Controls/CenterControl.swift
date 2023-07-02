//
//  CenterControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct CenterControl: View {

    @Environment(\.colorScheme) var colorScheme

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if vm.showAI {
                LeadingHStack {
                    Text("Why is active recall so powerful?")
                        .font(.system(size: UIConstants.body).weight(.semibold))
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 11)
                .background(Color.yellow.opacity(0.3))
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
                    if !vm.showAI {
                        Spacer()
                    }

                    SymbolButton(
                        symbol: "waveform",
                        foreground: vm.showAI ? .mainColorInvert : .primary.opacity(0.9),
                        background: vm.showAI ? .main : Color.clear
                    ) {
                        withAnimation(.defaultSpring) {
                            vm.showAI.toggle()
                        }

                        if vm.showAI {

                        } else {
                            cm.studySelect = nil
                        }
                    }
                    .symbolEffect(.bounce, value: vm.showAI ? bounced : false)
                    .onReceive(timer) { _ in
                        bounced.toggle()
                    }

                    Spacer()
                }

                SymbolButton(
                    symbol: "ellipsis",
                    foreground: vm.shipState == .misc ? .mainColorInvert : .primary.opacity(0.9),
                    background: vm.shipState == .misc ? .main : Color.clear
                ) {
                    withAnimation(.defaultSpring) {
                        vm.showAI = false

                        if vm.shipState == nil {
                            vm.shipState = .misc
                        } else {
                            vm.shipState = nil
                        }
                    }
                }
                .opacity(vm.showAI ? 0 : 1)

                Spacer()
            }
            .padding(.horizontal, 24)
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
