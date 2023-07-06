//
//  Block.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

enum BlockType: String, Codable {
    case rootBlock
    case textBlock
}

enum TextType: String, Codable {
    case body
    case header
    case math
    case code
}

enum Foldable: String, Codable {
    case fold
    case open
}

@Observable
class Block: Identifiable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.children == rhs.children
    }


    let id: String

    var type: BlockType = .textBlock

    // Foldable
    var foldable: Foldable? = nil
    var children: [String]? = nil

    // Image
    var imageSrc: URL? = nil

    // Text block
    var textType: TextType? = nil
    var text: String? = nil
    var styles: Set<TextStyle>? = nil
    var listStyle: ListStyle? = nil
    var align: Alignment? = nil

    init(
        id: String?=nil,
        type: BlockType,
        foldable: Foldable? = nil,
        children: [String]? = nil,
        text: String? = nil,
        textType: TextType? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.type = type
        self.foldable = foldable
        self.children = children
        self.text = text

        if type == .textBlock {
            self.textType = textType ?? .body
            align = .leading
        }
    }
}
