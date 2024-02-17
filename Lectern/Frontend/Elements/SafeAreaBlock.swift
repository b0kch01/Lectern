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

    var height: CGFloat = 190

    var minimized: Bool = false

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 16)
            .contrast(1.05)
            .offset(
                y:
                    -height/(minimized ? 1.5 : (sizeClass == .compact ? 3.5 : 2.1))
            )
    }
}

struct SafeAreaBlockBottom: View {

    @Environment(\.colorScheme) private var colorScheme

    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var height: CGFloat = 180

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 13)
            .contrast(1.05)
            .offset(
                y:
                    height/5
            )
    }
}

struct NoteSafeAreaBlock: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) private var colorScheme

    @Environment(NavigationViewModel.self) var nvm

    var height: CGFloat = 160

    var minimized: Bool = false

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 16)
            .brightness(-0.1)
            .offset(
                y:
                    -height/(minimized ? 1.5 : (sizeClass == .compact ? 3.5 : 2.1))
            )
    }
}

struct NoteSafeAreaBlockBottom: View {

    @Environment(\.colorScheme) private var colorScheme

    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var height: CGFloat = 180

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 16)
            .brightness(-0.1)
            .offset(
                y:
                    height/5
            )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
