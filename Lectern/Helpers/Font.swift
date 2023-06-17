//
//  Font.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import Foundation
import UIKit

extension UIFont {
    func withTraits(traits: [UIFontDescriptor.SymbolicTraits?]) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(
                traits.compactMap { $0 }
            ))

        return UIFont(descriptor: descriptor!, size: 0)
    }
}
