//
//  StudyView.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI

struct StudyView: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        Group {
            if vm.showAI {
                ScrollView {
                    VStack(spacing: 40) {
                        HStack(spacing: 0) {
                            Text("Why is active recall so powerful")
                                .font(Font.custom("OpenRunde-Medium", size: 16))
                                .foregroundStyle(Color(.tertiaryLabel))
                                .multilineTextAlignment(.leading)

                            Spacer()
                        }
                        .padding(.trailing, UIScreen.main.bounds.width / 4)

                        HStack(spacing: 0) {
                            Spacer()

                            Text("Active recall is a highly effective study technique because it forces the brain to actively engage with the material, strengthening memory and enhancing learning.")
                                .font(Font.custom("OpenRunde-Medium", size: 16))
                                .foregroundStyle(.main)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.leading, UIScreen.main.bounds.width / 4)

                        HStack(spacing: 0) {
                            Text("That's... pretty bad.")
                                .font(Font.custom("OpenRunde-Medium", size: 16))
                                .foregroundStyle(.main)
                                .multilineTextAlignment(.leading)

                            Spacer()
                        }
                        .padding(.trailing, UIScreen.main.bounds.width / 4)

                        HStack(spacing: 0) {
                            Spacer()

                            Text("Tap \(Image(systemName: "mic.fill")) and start speaking or tap to start typing.")
                                .font(Font.custom("OpenRunde-Medium", size: 16))
                                .foregroundStyle(Color(.tertiaryLabel))
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.leading, UIScreen.main.bounds.width / 4)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 120 + safeAreaInsets.top)
                    .padding(.bottom, 120)
                    .frame(width: UIScreen.main.bounds.width)
                }
                .transition(.scale)
            }
        }
        .blur(radius: !vm.showAI ? 10 : 0)
        .opacity(!vm.showAI ? 0 : 1)
    }
}
