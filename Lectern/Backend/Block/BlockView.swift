//
//  BlockView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct BlockView: View {

    @Environment(ContentManager.self) var cm

    let blockId: String

    init(_ blockId: String) {
        self.blockId = blockId
    }

    var body: some View {
        if let block = cm.contentTree[blockId] {
            switch block.type {
            case .rootBlock: Text("ROOT VIEW")
            case .textBlock:
                if let children = block.children {
                    FoldableBlock {
                        ForEach(children, id: \.self) { blockId in
                            BlockView(blockId)
                                .id(blockId)
                        }
                    } label: {
                        TextBlock(block) { range in
                            cm.newlineAction(targetId: block.id, range: range)
                        } deleteAction: {
                            cm.removeTextBlockCurrent(targetId: block.id)
                        }
                    }
                } else {
                    TextBlock(block) { range in
                        cm.newlineAction(targetId: block.id, range: range)
                    } deleteAction: {
                        cm.removeTextBlockCurrent(targetId: block.id)
                    }
                }
            }
        }
    }
}
