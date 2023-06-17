//
//  UIApplication.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension UIApplication {
    var firstWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?
            .windows.first
    }
}
