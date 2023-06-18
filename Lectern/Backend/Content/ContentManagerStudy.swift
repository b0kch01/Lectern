//
//  ContentManagerStudy.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

struct GPTResponse: Codable {
    let role: String
    let content: String
}

struct StudyFeedback: Codable {
    let id: String
    let feedback: String
}

extension ContentManager {

    func practice() -> String {
        withAnimation(.snappy) {
            studyState = .blurting
        }

        if contentTree["root"]?.children?.contains(studySelect ?? "") != true {
            withAnimation(.snappy) {
                studySelect = contentTree["root"]?.children?.first(where: { contentTree[$0]?.children?.contains(studySelect ?? "") == true })
            }
        }

        let url = URL(string: URL_K.practice)!

        Task {
            var req = URLRequest(url: url)

            let list: [String] = Array(study.values.map { "\($0.id): \($0.feedback)" })
            let feedback = "FEEDBACK\n\(list.joined(separator: "\n"))\nEND FEEDBACK"

            req.setValue(contentTree[studySelect!]!.text,           forHTTPHeaderField: "heading")
            req.setValue(blurtVM.savedText.joined(separator: " "),  forHTTPHeaderField: "transcript")
            req.setValue(getNotes().replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "notes")
            req.setValue(feedback.replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "previous_feedback")

            do {
                let (data, _) = try await URLSession.shared.data(for: req)
                print(String(data: data, encoding: .utf8))

                let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    self?.study = self?.parsePractice(gptResponse.content) ?? [:]
                    self?.studyState = .idle
                }
            } catch {
                print(error)
                studyState = .idle
            }
        }
    }

    private func parsePractice(_ content: String) {
        
    }

    func getNotes() -> String {
        guard let studySelect else { return "" }

        let notes = contentTree[studySelect]!
            .children?
            .filter { contentTree[$0] != nil && contentTree[$0]!.text != nil }
            .map { $0 + ": " + contentTree[$0]!.text! }
            .joined(separator: "\n") ?? ""

        return notes
    }

    func blurt() {
        if studyState == .blurting { return }
        withAnimation(.snappy) {
            studyState = .blurting
        }

        if contentTree["root"]?.children?.contains(studySelect ?? "") != true {
            withAnimation(.snappy) {
                studySelect = contentTree["root"]?.children?.first(where: { contentTree[$0]?.children?.contains(studySelect ?? "") == true })
            }
        }

        let url = URL(string: URL_K.blurt)!

        Task {
            var req = URLRequest(url: url)

            req.setValue(contentTree[studySelect!]!.text,           forHTTPHeaderField: "heading")
            req.setValue(blurtVM.savedText.joined(separator: " "),  forHTTPHeaderField: "transcript")
            req.setValue(getNotes().replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "notes")

            do {
                let (data, _) = try await URLSession.shared.data(for: req)
                print(String(data: data, encoding: .utf8))

                let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    self?.study = self?.parseBlurt(gptResponse.content) ?? [:]
                    self?.studyState = .idle
                }
            } catch {
                print(error)
                studyState = .idle
            }
        }
    }

    private func parseBlurt(_ content: String) -> [String: StudyFeedback] {
        var lines = content.components(separatedBy: "\n")

        if lines.count <= 3 {
            return [:]
        } else {
            lines = Array(lines[1..<lines.count-1])
        }

        return lines.reduce(into: [String: StudyFeedback]()) {
            let parts = $1.split(separator: ": ", maxSplits: 1)
            if parts.count == 2 {
                let id = String(parts[0])
                let feedback = String(parts[1])
                
                $0[id] = StudyFeedback(id: id, feedback: feedback)
            }
        }
    }
}
