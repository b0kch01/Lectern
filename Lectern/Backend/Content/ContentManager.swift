//
//  ContentManager.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation
import SwiftData

enum StudyStatus: Hashable {
    case idle
    case transcribing
    case transcribingPaused
    case blurting
}

@Observable
class ContentManager {


    let sr = SpeechRecognizer()
    // STUDY STUFF

    var study: [String: StudyFeedback] = [:]
    var studyState = StudyStatus.idle

    var blurtVM = BlurtViewModel()

    var studySelect: String? = nil



    // DO NOT PUBLISH
    var selectState: NSRange? = NSRange(location: 0, length: 0)

    var focusState: String? = nil
    var contentTree: [String: Block] = [
        "root": Block(id: "root", type: .rootBlock, children: ["1", "5"]),
        "1": Block(id: "1", type: .textBlock, children: ["2", "3", "4"], text: "The “Success Frame”", textType: .header),
        "2": Block(id: "2", type: .textBlock, text: "Constructed and promoted by hyper-selected Asian immigrant subgroups which can affect other Asian subgroups", textType: .body),
        "3": Block(id: "3", type: .textBlock, text: "Stereotype about robotic-like thinking came after 1965:", textType: .body),
        "4": Block(id: "4", type: .textBlock, text: "Institutions make race real and potent in society", textType: .body),
        "5": Block(id: "5", type: .textBlock, children: ["6", "7"], text: "How to make API Calls", textType: .header),
        "6": Block(id: "6", type: .textBlock, text: "Popular Types: GET, POST, PUT, PATCH, DELETE", textType: .body),
        "7": Block(id: "7", type: .textBlock, text: "Some api calls allow you to put body content, which is url encoded", textType: .body)
    ]

   

    func ensureGhostBlockExists() {
        if let ghostId = contentTree["root"]?.children?.last,
           let ghostBlockText = contentTree[ghostId]?.text,
           ghostBlockText.count > 0
        {
            let (newId, newBlock) = createNewBlock(blockType: .textBlock)
            contentTree[newId] = newBlock
            contentTree["root"]?.children?.append(newId)
        }
    }

    func createNewBlock(blockType: BlockType) -> (String, Block) {
        let id = UUID().uuidString

        if blockType == .textBlock {
            return (id, Block(id: id, type: .textBlock, text: ""))
        }

        return (id, Block(id: id, type: blockType))
    }

    func focusBlock(targetId: String, completion: (() -> Void)?=nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.focusState = targetId
        }
        completion?()
    }

    func insertTextBlock(parentId: String, childIndex: Int, range: NSRange) {
        let (newId, newBlock) = createNewBlock(blockType: .textBlock)

        withAnimation(nil) {
            contentTree[newId] = newBlock
            contentTree[parentId]?.children?.insert(newId, at: childIndex)
        }
    }

    func appendTextBlock(targetId: String, parentId: String, childIndex: Int, range: NSRange) {
        let (newId, newBlock) = createNewBlock(blockType: .textBlock)

        if let text = contentTree[targetId]?.text {
            newBlock.text = String(text.suffix(text.unicodeCount - range.location))
            contentTree[targetId]?.text = String(text.prefix(range.location))
        }

        withAnimation(nil) {
            contentTree[newId] = newBlock
            contentTree[parentId]?.children?.insert(newId, at: childIndex + 1)
        }

        setSelectState(0)
        focusBlock(targetId: newId)
    }

    func newlineAction(targetId: String, range: NSRange) {
        for (id, block) in contentTree {
            guard let children = block.children else { continue }

            for (childIndex, childId) in children.enumerated() where childId == targetId {
                if let text = contentTree[targetId]?.text, range.location > 0 || range.length > 0 {
                    if let swiftuiRange: Range<String.Index> = Range(range, in: text) {
                        contentTree[targetId]?.text?.removeSubrange(swiftuiRange)
                    }
                }

                if range.location == 0 && (contentTree[targetId]?.text ?? "").count > 0 {
                    insertTextBlock(parentId: id, childIndex: childIndex, range: range)
                } else {
                    appendTextBlock(targetId: targetId, parentId: id, childIndex: childIndex, range: range)
                }

                return
            }
        }
    }

    func setSelectState(targetId: String?) {
        guard let targetId, let text = contentTree[targetId]?.text else {
            selectState = nil
            return
        }
        selectState = NSRange(location: text.count, length: 0)
    }
    func setSelectState(text: String?) {
        guard let text else {
            selectState = nil
            return
        }
        selectState = NSRange(location: text.count, length: 0)
    }
    func setSelectState(_ location: Int?) {
        guard let location else {
            selectState = nil
            return
        }
        selectState = NSRange(location: location, length: 0)
    }

    func safeAppend(targetId: String, string: String?) {
        let text = contentTree[targetId]?.text ?? ""

        if contentTree[targetId]?.text == nil {
            contentTree[targetId]?.text = text
        } else {
            contentTree[targetId]?.text?.append(string ?? "")
        }
    }

    func removeTextBlockCurrent(targetId: String) {
        for (id, block) in contentTree {
            guard let children = block.children else { continue }

            for (childIndex, childId) in children.enumerated() where childId == targetId {
                // Switch focus and append previous text to previous block
                if childIndex > 0, let newFocusId = contentTree[id]?.children?[childIndex - 1] {
                    setSelectState(targetId: newFocusId)
                    focusBlock(targetId: newFocusId)
                    safeAppend(targetId: newFocusId, string: contentTree[targetId]?.text)
                } else {
                    setSelectState(targetId: id)
                    focusBlock(targetId: block.id)
                    safeAppend(targetId: id, string: contentTree[targetId]?.text)
                }

                // Delete target block completely
                withAnimation(nil) {
                    self.contentTree[id]?.children?.remove(at: childIndex)
                    self.contentTree.removeValue(forKey: targetId)
                }

                return
            }
        }
    }

    func removeBlock(targetId: String) {
        for (id, block) in contentTree {
            guard let children = block.children else { continue }

            for (childIndex, childId) in children.enumerated() where childId == targetId {
                withAnimation(.defaultSpring) {
                    self.contentTree[id]?.children?.remove(at: childIndex)
                    self.contentTree.removeValue(forKey: targetId)
                }

                return
            }
        }
    }

    func exportAllBlocks() -> String {
        if let root = contentTree["root"] {
            return exportBlockToText(parent: root)
        } else {
            return "Error: document is empty (missing root)"
        }
    }

    func exportBlockToText(parent: Block) -> String {
        var output = ""

        parent.children?.forEach { childId in
            if let child = contentTree[childId] {
                // Add current text
                output += (child.text ?? "") + "\n"
                // Add text of children recursively
                if child.children?.count ?? 0 > 0 {
                    output += exportBlockToText(parent: child)
                }
            }
        }

        return output
    }
}
