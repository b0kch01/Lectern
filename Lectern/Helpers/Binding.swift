//
//  Binding.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension Binding {
    func equalTo<A: Equatable>(_ value: A) -> Binding<Bool> where Value == A? {
        Binding<Bool>(
            get: { wrappedValue == value },
            set: {
                if $0 {
                    wrappedValue = value
                } else if wrappedValue == value {
                    wrappedValue = nil
                }
            }
        )
    }

    func `default`<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
