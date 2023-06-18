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
        studyState = .blurting

        let url = URL(string: URL_K.blurt)!


        Task {
            var req = URLRequest(url: url)

            req.setValue(contentTree[studySelect!]!.text,           forHTTPHeaderField: "heading")
            req.setValue(blurtVM.savedText.joined(separator: " "),  forHTTPHeaderField: "transcript")
            req.setValue(getNotes().replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "notes")

            do {
                let (data, res) = try await URLSession.shared.data(for: req)

                let x = String(data: data, encoding: .utf8)

                let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    self?.study = self?.parseBlurt(gptResponse.content) ?? [:]
                    self?.studyState = .idle
                }
            } catch {
                logger.error("\(error)")
                studyState = .idle
            }
        }
    }

    private func parseBlurt(_ content: String) -> [String: StudyFeedback] {
        var lines = content.components(separatedBy: "\n")
            lines = Array(lines[1..<lines.count-1])

        return lines.reduce(into: [String: StudyFeedback]()) {
            let parts = $1.split(separator: ": ", maxSplits: 1)
            let id = String(parts[0])
            let feedback = String(parts[1])

            $0[id] = StudyFeedback(id: id, feedback: feedback)
        }
    }
}
