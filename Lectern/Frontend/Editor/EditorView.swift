//
//  EditorView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct EditorView: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        Group {
            if !vm.showAI {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(1...6, id: \.self) { number in
                            let imageName = String(format: "2006_CBR600RR 2-%03d", number)
                            Image(imageName).resizable()
                                .aspectRatio(contentMode: .fill)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .stroke(.borderBackground, lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
                                .shadow(color: Color.black.opacity(0.1), radius: 10)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 80 + safeAreaInsets.top)
                    .padding(.bottom, 120)
                    .frame(width: UIScreen.main.bounds.width)
                }
                .transition(.scale)
            }
        }
        .opacity(vm.showAI ? 0 : 1)
        .blur(radius: vm.showAI ? 10 : 0)
    }
}
