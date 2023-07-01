//
//  TestBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

import Observation

struct AlphaTextBlock: View {

    @Environment(EditorViewModel.self) var editorView
    @Environment(AlphaContentManager.self) var contentManager

    @Bindable var block: AlphaBlock

    @State var t = ""

    var body: some View {
        TextField("Type / for more templates", text: $t, axis: .vertical)
            .padding(.vertical, 5)
            .onKeyPress(.tab) {
                contentManager.indent(block)
                return .handled
            }
            .onKeyPress(.return) {
                return .handled
            }
            .onKeyPress("/") {
                return .handled
            }
    }
}

struct TestBlock: View {

    @Environment(AlphaContentManager.self) var cm

    var block: AlphaBlock

    @State var oldHeight: CGFloat = 0

    var body: some View {
//        AlphaTextBlock(block: block)
        main
            .background(ViewGeometry(id: block.id, hideImmediately: block.hide))
    }

    @ViewBuilder
    var main: some View {
        if !block.hide {
            VStack(alignment: .leading) {
                AlphaTextBlock(block: block)

                Divider()

                HStack(spacing: 10) {
                    Text("ID: \(block.id);")
                        .foregroundStyle(.secondary)
                    Text("Indent: \(block.indent);")
                        .foregroundStyle(.blue)
                    Text("Height: ~\(Int(lineHeight))pt")
                        .foregroundStyle(.purple)
                }
                .font(.system(.caption, design: .monospaced))

                Divider()

                HStack(spacing: 0) {
                    Image(systemName: "arrowtriangle.forward.fill")
                        .rotationEffect(.degrees(block.fold ? 0 : 90))
                        .animation(.defaultSpring, value: block.fold)
                        .padding(.horizontal, 7)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            cm.toggleFold(block)
                        }

                    Divider()

                    Image(systemName: "increase.indent")
                        .padding(.horizontal, 24)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            cm.indent(block)
                        }

                    Divider()

                    Image(systemName: "decrease.indent")
                        .padding(.horizontal, 24)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            cm.unindent(block)
                        }
                }
                .padding(.vertical, 1)
                .font(.system(size: 12))
                .fontWeight(.bold)
            }
            .font(.caption)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .padding(.horizontal, -7)
            )
            .overlay(
                ThreadLine(collapse: .constant(false))
                    .frame(height: block.fold ? 0 : lineHeight)
                    .clipped()
                    .offset(y: cm.sizes[block.id]?.height ?? 0)
                ,
                alignment: .topLeading
            )
            .padding(.vertical, 5)
            .padding(.leading, CGFloat(block.indent) * 30)
        }
    }

    private var lineHeight: CGFloat {
        guard let startIndex = cm.content.firstIndex(where: { $0.id == block.id }) else {
            return .zero
        }

        var totalHeight: CGFloat = 0

        for i in (startIndex+1)..<cm.content.endIndex {
            if cm.content[i].indent <= block.indent {
                return totalHeight
            }
            totalHeight += cm.sizes[cm.content[i].id]?.height ?? 0
        }

        return totalHeight
    }
}
