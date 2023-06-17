//
//  ContentManagerFolding.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension ContentManager {

    func indent(targetIds: Set<String>) {
        for targetId in targetIds {
            indent(targetId: targetId)
        }
    }

    func indent(targetId: String) {
        for (parentId, parentBlock) in contentTree {
            guard let children = parentBlock.children else { continue }

            // Find the target block within parent
            for(targetIndex, searchId) in children.enumerated() where searchId == targetId {
                // Child must have a sibling above
                if targetIndex < 1 { return }


            }

        }
    }

    func unindent() {

    }

}
