//
//  PlaceholderView.swift
//  Lectern
//
//  Created by Paul Wong on 2/17/24.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .stroke(Color(.systemFill), lineWidth: 1)
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 245)
            .overlay(
                VStack(spacing: 20) {
                    Text("Nothing to see here")
                        .font(Font.custom("OpenRunde-Semibold", size: 16))
                        .foregroundColor(.main)

                    Text("Tap \(Image(systemName: "folder")) to import files or \(Image(systemName: "doc.viewfinder")) to scan documents.")
                        .font(Font.custom("OpenRunde-Regular", size: 14))
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            )
    }
}
