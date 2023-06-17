//
//  AlphaContentManager.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

@Observable
class AlphaContentManager {

    public var content: [AlphaBlock] = [
        AlphaBlock(id: "one", text: "Hello, world!"),
        AlphaBlock(id: "two", text: "Nooooooooo, what is happening?"),
        AlphaBlock(id: "three", text: "Nooooooooo, what is happening?"),
        AlphaBlock(id: "four", text: "Nooooooooo, what is happening?"),
        AlphaBlock(id: "five", text: "Nooooooooo, what is happening?"),
        AlphaBlock(id: "six", text: "Nooooooooo, what is happening?")
    ]

    public var sizes: [String: CGSize] = [:]

    func addIndent(block: AlphaBlock, indent: Int) {
        block.indent += indent
    }
    func setHide(block: AlphaBlock, hide: Bool) {
        block.hide = hide
    }
    func blockIndex(_ blockID: String) -> Int? {
        return content.firstIndex { $0.id == blockID }
    }

    func fold(_ block: AlphaBlock) { fold(block, true) }
    func fold(_ block: AlphaBlock, _ folding: Bool) {
        guard let blockIndex = blockIndex(block.id) else { return }

        content[blockIndex].fold = folding
        let originalIndent = content[blockIndex].indent

        var hiddenIndex = Int.max

        for i in (blockIndex+1)..<content.endIndex {
            if content[i].indent <= originalIndent {
                return
            }

            // If folding, hide all blocks
            if folding {
                setHide(block: content[i], hide: true)
            }

            // If unfolding, respect deeper folds
            else if content[i].indent < hiddenIndex {
                if content[i].fold {
                    hiddenIndex = content[i].indent + 1
                } else {
                    hiddenIndex = Int.max
                }
                setHide(block: content[i], hide: false)
            }
        }
    }

    func unfold(_ block: AlphaBlock) { fold(block, false) }

    func toggleFold(_ block: AlphaBlock) {
        fold(block, !block.fold)
    }

    func indent(_ block: AlphaBlock) {
        unfold(block)
        guard var blockIndex = blockIndex(block.id) else { return }
        guard let olderSibling = content[safe: blockIndex - 1] else { return }

        let originalIndent = content[blockIndex].indent

        // Unfold blocks that is being entered into
        for i in (0..<blockIndex).reversed() {
            if content[i].indent == originalIndent {
                unfold(content[i])
                break
            }
        }

        if olderSibling.indent - content[blockIndex].indent > -1 {
            while (blockIndex < content.endIndex) {
                addIndent(
                    block: content[blockIndex],
                    indent: content[blockIndex].indent < 5 ? 1 : 0
                )
                blockIndex += 1

                if (blockIndex >= content.endIndex ||
                    content[blockIndex].indent <= originalIndent) { return }
            }
        }
    }

    func unindent(_ block: AlphaBlock) {
        unfold(block)
        guard var blockIndex = blockIndex(block.id) else { return }

        let originalIndent = content[blockIndex].indent

        while (blockIndex < content.endIndex) {
            addIndent(
                block: content[blockIndex],
                indent: content[blockIndex].indent > 0 ? -1 : 0
            )

            blockIndex += 1

            if (blockIndex >= content.endIndex ||
                content[blockIndex].indent <= originalIndent) { return }
        }
    }


}

#Preview {
    AlphaEditorView()
}
