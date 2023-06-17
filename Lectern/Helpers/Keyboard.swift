//
//  Keyboard.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension AnimatableModifier {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct KeyboardResponsiveModifier: ViewModifier {

    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear {
                withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main
                    ) { notif in
                        guard
                            let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                        else { return }

                        let bottomInset = UIApplication.shared.firstWindow?.safeAreaInsets.bottom
                        self.offset = value.height - (bottomInset ?? 0)
                    }

                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main
                    ) { _ in
                        self.offset = 0
                    }
                }
            }
    }
}

extension View {
    func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
        return modifier(KeyboardResponsiveModifier())
    }
}
