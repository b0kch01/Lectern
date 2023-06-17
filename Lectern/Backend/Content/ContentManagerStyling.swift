//
//  ContentManagerStyling.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

extension ContentManager {

    // MARK: - TextType
    func isTyped(_ type: TextType, selected: Set<String>) -> Bool {
        return !selected.isEmpty && selected.allSatisfy { id in
            contentTree[id]?.textType == type
        }
    }

    func setType(_ type: TextType, selected: Set<String>) {
        withAnimation(.defaultSpring) {
            for id in selected {
                contentTree[id]?.textType = type
            }
        }
    }


    // MARK: - Styled functions
    func styled(for style: BentoTextStyle, selected: Set<String>) -> Bool {
        return !selected.isEmpty && selected.allSatisfy { id in
            contentTree[id]?.hasStyle(style) == true
        }
    }

    // MARK: - Utility style functions

    func toggleStyle(for style: BentoTextStyle, selected: Set<String>) {
        if styled(for: style, selected: selected) {
            removeStyle(for: style, selected: selected)
        } else {
            setStyle(for: style, selected: selected)
        }
    }

    func setStyle(for style: BentoTextStyle, selected: Set<String>) {
        for id in selected {
            contentTree[id]?.addStyle(style)
        }
    }

    func removeStyle(for style: BentoTextStyle, selected: Set<String>) {
        for id in selected {
            contentTree[id]?.removeStyle(style)
        }
    }
}
