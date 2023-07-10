//
//  FormatControl.swift
//  Lectern
//
//  Created by Paul Wong on 7/10/23.
//

import SwiftUI

struct FormatControl: View {

    @Environment(EditorViewModel.self) var vm

    var body: some View {
        HStack(spacing: 5) {
            SymbolButton(symbol: "ellipsis") { }
                .opacity(0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    Group {
                        SymbolButton(symbol: "arrow.uturn.left")
                        SymbolButton(symbol: "arrow.uturn.right")
                    }

                    VerticalBar(color: Color(.secondarySystemFill), height: 19)

                    Group {
                        SymbolButton(symbol: "doc.on.doc")
                        SymbolButton(symbol: "scissors")
                        SymbolButton(symbol: "rectangle.portrait.on.rectangle.portrait")
                    }
                    .opacity(!vm.selected.isEmpty ? 1 : 0.3)
                    .disabled(!vm.selected.isEmpty ? false : true)

                    VerticalBar(color: Color(.secondarySystemFill), height: 19)

                    Group {
                        SymbolButton(symbol: "square.and.arrow.up")
                        SymbolButton(symbol: "info.circle")
                    }

                }
                .padding(.horizontal, 24)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.1)
            ]), startPoint: .leading, endPoint: .trailing))
        }
    }
}

