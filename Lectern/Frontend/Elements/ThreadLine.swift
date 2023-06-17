//
//  ThreadLine.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

// swiftlint:disable line_length
struct ThreadLine: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(EditorViewModel.self) var vm

    @State var color: Color = .lineBackground

    let lineSize: CGFloat = 11
    let lineSizeHalf: CGFloat = 11/2

    @Binding var collapse: Bool

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(color)
                .frame(width: 3)

            if collapse {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(to: CGPoint(x: lineSizeHalf, y: lineSizeHalf), control: CGPoint(x: 0, y: lineSizeHalf))
                    path.addQuadCurve(to: CGPoint(x: lineSizeHalf*2, y: 0), control: CGPoint(x: lineSizeHalf*2, y: lineSizeHalf))
                    path.addQuadCurve(to: CGPoint(x: lineSizeHalf, y: -lineSizeHalf), control: CGPoint(x: lineSizeHalf*2, y: -lineSizeHalf))
                    path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: 0, y: -lineSizeHalf))
                    path.addLines([CGPoint(x: 0, y: 0), CGPoint(x: 0, y: lineSizeHalf)])
                    path.addQuadCurve(to: CGPoint(x: lineSizeHalf*2, y: lineSizeHalf*2.5), control: CGPoint(x: 0, y: lineSizeHalf*2.9))
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: lineSize, height: lineSize)
                .offset(x: lineSize/2, y: (-lineSize/2) + 2)
            } else {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(to: CGPoint(x: lineSize, y: lineSize), control: CGPoint(x: 0, y: lineSize))
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: lineSize, height: lineSize)
                .offset(x: lineSize/2, y: (-lineSize/2) + 2)
            }
        }
        .padding(.bottom, 12)
        .padding(.leading, 16)
        .contentShape(Rectangle())
        .padding(.leading, -16)
        .padding(.trailing, sizeClass == .compact ? 16 : 24)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                collapse.toggle()
            }
        }
        .zIndex(-100)
    }
}
