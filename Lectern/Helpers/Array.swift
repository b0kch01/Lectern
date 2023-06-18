//
//  Array.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

extension Array where Element: Hashable {
    /// Makes a set, finds the difference, and returns it as a list
    func difference(between other: [Element]) -> [Element] {
        let current = Set(self)
        return Array(current.symmetricDifference(other))
    }
}
