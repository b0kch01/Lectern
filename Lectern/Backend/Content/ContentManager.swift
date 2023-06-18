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
    case practicing
    case practicingPaused
}

@Observable
class ContentManager {

    let sr = SpeechRecognizer()
    // STUDY STUFF

    var questions: [StudyQuestion] = []
    var study: [String: StudyFeedback] = [:]
    var studyState = StudyStatus.idle

    var blurtVM: BlurtViewModel {
        if studyState == .practicing || studyState == .practicingPaused {
            return blurtPracticeVM
        } else {
            return blurtViewVM
        }
    }
    var blurtViewVM = BlurtViewModel()
    var blurtPracticeVM = BlurtViewModel()

    var studySelect: String? = nil

    // DO NOT PUBLISH
    var selectState: NSRange? = NSRange(location: 0, length: 0)

    var focusState: String? = nil
    var contentTree: [String: Block] = [
        "root": Block(id: "root", type: .rootBlock, children: ["1", "3", "5", "8", "11"]),
        "1": Block(id: "1", type: .textBlock, children: ["2"], text: "What is Lectern?", textType: .header),
        "2": Block(id: "2", type: .textBlock, text: "Lectern is an app that streamlines learning by leveraging AI technology in speech recognition, image recognition, and text generation. Incorporating learning techniques like the Feynman technique and active recall, Lectern integrates the techniques with active user vocal participation to foster effective and efficient learning.", textType: .body),
        "3": Block(id: "3", type: .textBlock, children: ["4"], text: "The Feynman technique", textType: .header),
        "4": Block(id: "4", type: .textBlock, text: "The Feynman technique is a simple step process of learning, involving the breakdown of complex ideas into simpler and more manageable pieces of information. These steps include studying, teaching, filling the gaps, and simplifying.", textType: .body),
        "5": Block(id: "5", type: .textBlock, children: ["6", "7"], text: "Why is active recall so powerful?", textType: .header),
        "6": Block(id: "6", type: .textBlock, text: "The Feynmen technique introduces active recall, a technique that involves actively retrieving information from memory rather than simply reviewing or re-reading material passively.", textType: .body),
        "7": Block(id: "7", type: .textBlock, text: "Instead of reading the same text repeatedly, active recall forces you to remember what you have already read. Lectern uses this process and provides feeedback on what you might have forgotten.", textType: .body),
        "8": Block(id: "5", type: .textBlock, children: ["9", "10"], text: "Speech-to-text and Blurting", textType: .header),
        "9": Block(id: "6", type: .textBlock, text: "With Lectern, we introduced a speech-to-text that effciently and accurately transcribes spoken content to text, allowing for AI processes.", textType: .body),
        "10": Block(id: "7", type: .textBlock, text: "Speaking is often regarded as a superior way to memorize content. With Blurting, you become a teacher, teaching the AI what you know. In turn, the AI will respond with what you may be lacking.", textType: .body),
        "11": Block(id: "5", type: .textBlock, children: ["12"], text: "Integration with AI", textType: .header),
        "12": Block(id: "6", type: .textBlock, text: "Along with OpenAI's sophisticated GPT models, Lectern also utilizes Apple's CoreML to accelerate AI process. With Optical Character Recognition (OCR), Lectern is able to recognize scribbles, allowing you to jot down notes with an Apple Pencil instead of a keyboard.", textType: .body)
    ]

    func skip(n: Int) {
        if contentTree["root"]?.children?.contains(studySelect ?? "") != true {
            withAnimation(.snappy) {
                studySelect = contentTree["root"]?.children?.first(where: { contentTree[$0]?.children?.contains(studySelect ?? "") == true })
            }
        }

        guard let list = contentTree["root"]?.children else { return }

        for i in list.indices where list[i] == studySelect {
            if i + n < 0 || i + n >= list.count {
                return
            }

            studySelect = list[i + n]
            print("SKIPPED TO", list[i+n])
        }
    }
   

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
