//
//  TextBlockViewModel.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

protocol BentoTextStyle {

}

/// Bento text styles
public enum TextStyle: BentoTextStyle, Codable {
    case bold
    case italic
    case underline
    case strikethrough
    case refresh // Update the view just in case of wierd UI shifts
}

/// Bento list styles
public enum ListStyle: BentoTextStyle, Codable {
    case ol
    case ul
    case todo
}

/// Bento alignment
public enum Alignment: BentoTextStyle, Codable {
    case leading
    case center
    case trailing
    case uniform
}

final class TextBlockViewModel: ObservableObject {

    @Published var text: String
    @Published var styles: [TextStyle]
    @Published var listStyle: ListStyle?
    @Published var align: Alignment

    @Published var geometryProxy: GeometryProxy?

    let id: String

    init(
        id: String,
        text: String?=nil,
        styles: [TextStyle]?=nil,
        listStyle: ListStyle?=nil,
        align: Alignment?=nil
    ) {
        self.text = text ?? ""
        self.styles = styles ?? []
        self.listStyle = listStyle
        self.align = align ?? .leading
        self.id = id
    }

    func toggleStyle(_ style: TextStyle) {
        withAnimation(.spring(response: 0.15, dampingFraction: 1)) {
            if styles.contains(style) {
                styles.removeAll { $0 == style }

//                // Workaround view no updating to revert back to original height.
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
//                    self?.toggleStyle(.refresh)
//                }
            } else {
                styles.append(style)
            }
        }
    }

    func toggleListStyle(_ style: ListStyle) {
        withAnimation(.spring(response: 0.15, dampingFraction: 1)) {
            if listStyle == style {
                listStyle = nil
            } else {
                listStyle = style
            }
        }
    }
}
