//
//  SafeAreaBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import VariableBlurView

struct SafeAreaBlockTop: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) private var colorScheme

    @Environment(NavigationViewModel.self) var nvm

    @State var height: CGFloat = 150

    var minimized: Bool = false

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 10)
            .contrast(colorScheme == .dark ? 1.2 : 1)
            .offset(
                y:
                    -height/(minimized ? 1.5 : (sizeClass == .compact ? 3.5 : 2.1))
            )
            .opacity(nvm.showNoteSwitcher ? 0 : 1)
    }
}

struct SafeAreaBlockBottom: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
            .contrast(colorScheme == .dark ? 1.17 : 1)
            .opacity(nvm.showNoteSwitcher ? 0 : 1)
    }
}

struct NoteSafeAreaBlock: View {

    @State var height: CGFloat = 150

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 13)
            .contrast(1.3)
            .brightness(-0.9)
            .offset(
                y:
                    -height/1.4
            )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
