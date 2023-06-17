//
//  URL.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

extension String {
    func path(_ other: String) -> String {
        return self.hasSuffix("/") ? self + other : self + "/" + other
    }
}
