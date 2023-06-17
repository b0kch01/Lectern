//
//  Bar.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct Bar: View {

    var color: Color = Color(.tertiarySystemFill)

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}

struct VerticalBar: View {

    var color: Color = Color(.tertiarySystemFill)
    var height: CGFloat

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 1, height: height)
    }
}
