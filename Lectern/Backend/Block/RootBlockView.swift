//
//  RootBlockView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct RootBlockView: View {

    @Environment(ContentManager.self) var cm

    var body: some View {
        Group {
            if let rootChildren = cm.contentTree["root"]?.children {
                ForEach(rootChildren, id: \.self) { blockId in
                    BlockView(blockId)
                        .id(blockId)
                        .scrollTransition(axis: .vertical) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.7)
                        }
                }
            } else {
                Text("This isn't supposed to happen; Root view not found.")
            }
        }
    }
}
