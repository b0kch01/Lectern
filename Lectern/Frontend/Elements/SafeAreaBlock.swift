//
//  SafeAreaBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct SafeAreaBlock: View {

    @Environment(\.colorScheme) private var colorScheme

    @State var height: CGFloat = 150

    var isTop: Bool
    var isDark: Bool = false
    var minimized: Bool = false

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: isDark ? .systemMaterialLight : .systemUltraThinMaterial))
//        Color.red
            .frame(
                width: 9999,
                height: height
            )
            .padding(.horizontal, -200)
            .blur(radius: 20)
            .contrast(isDark ? 1.3 : (colorScheme == .dark ? 1.1 : 1))
            .brightness(isDark ? -0.9 : 0)
            .offset(y: isTop ? -height/(minimized ? (isDark ? 1.3 : 2) : 3.9) : (isDark ? height/4 : height/2.5))
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
