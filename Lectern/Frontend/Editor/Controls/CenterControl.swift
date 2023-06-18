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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Bar(color: Color(.secondarySystemFill))
                .padding(.horizontal, 30)

            HStack(spacing: 7) {
                if vm.shipState == nil {
                    if !vm.showAI {
                        Spacer()
                    }

                    Button(action: {
                        withAnimation(.defaultSpring) {
                            vm.showAI.toggle()
                        }

                        if vm.showAI {

                        } else {
                            cm.studySelect = nil
                        }
                    }) {
                        Image(.lectern)
                            .font(.system(size: 23).weight(.medium))
                            .symbolEffect(.bounce, value: vm.showAI)
                            .foregroundStyle(vm.showAI ? .mainColorInvert : .primary.opacity(0.9))
                            .frame(width: 18, height: 18)
                            .padding(9)
                            .background(vm.showAI ? .main : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                            .contentShape(Rectangle())
                            .hoverEffect(.highlight)
                    }

                    Spacer()
                }

                Button(action: {
                    withAnimation(.defaultSpring) {
                        vm.showAI = false

                        if vm.shipState == nil {
                            vm.shipState = .misc
                        } else {
                            vm.shipState = nil
                        }
                    }
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 19).weight(.medium))
                        .symbolEffect(.bounce, value: vm.shipState == .misc)
                        .foregroundStyle(vm.shipState == .misc ? .mainColorInvert : .primary.opacity(0.9))
                        .frame(width: 18, height: 18)
                        .padding(9)
                        .background(vm.shipState == .misc ? .main : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                        .contentShape(Rectangle())
                        .hoverEffect(.highlight)
                }
                .opacity(vm.showAI ? 0 : 1)

                Spacer()
            }
            .padding(.top, 13)
            .padding(.bottom, 16)
            .padding(.horizontal, 30)
            .overlay(
                MiscControl()
                    .opacity(vm.shipState == .misc ? 1 : 0)
            )
            .overlay(
                PlaybackControl()
                    .opacity(vm.showAI ? 1 : 0)
            )
            .foregroundStyle(.primary.opacity(0.9))
        }
    }
}
