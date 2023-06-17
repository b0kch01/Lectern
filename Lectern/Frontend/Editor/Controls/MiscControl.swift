//
//  MiscControl.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct MiscControl: View {

    @Environment(EditorViewModel.self) var vm

    var body: some View {
        HStack(spacing: 0) {
            SymbolButton(symbol: "ellipsis") { }
                .opacity(0)
                .padding(.trailing, 25)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
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
                .padding(.leading, 9)
                .padding(.trailing, 20)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.05),
                .init(color: .black, location: 0.85),
                .init(color: .clear, location: 1)
            ]), startPoint: .leading, endPoint: .trailing))
        }
    }
}
