//
//  AlphaBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

@Observable
final class AlphaBlock: Identifiable {

    let id: String
    var blockType: BlockType = .textBlock

    var indent: Int = 0

    // Text block
    var textType: TextType?=nil
    var text: String?=nil
    var styles: Set<TextStyle>?=nil
    var listStyle: ListStyle?=nil
    var align: Alignment?=nil

    var fold: Bool = false
    var hide: Bool = false

    init(id: String?=nil, blockType: BlockType?=nil, text: String?=nil) {
        self.id = id ?? UUID().uuidString
        self.blockType = blockType ?? .textBlock
        self.text = text
    }
}

struct BlockSizePreference: PreferenceKey {
    typealias Value = [String: CGSize]

    static var defaultValue: Value = [:]

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

struct ViewGeometry: View {

    var id: String
    var hideImmediately: Bool

    init(id: String, hideImmediately: Bool) {
        self.id = id
        self.hideImmediately = hideImmediately
    }

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: BlockSizePreference.self,
                    value: hideImmediately ? [id: CGSize.zero] : [id: geometry.size])
        }
    }
}
