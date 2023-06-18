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

    func blurt() {
        if studyState == .blurting { return }

        let url = URL(string: URL_K.blurt)!
        let req = URLRequest(url: url)

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: req)
                let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    self?.study = self?.parseBlurt(gptResponse.content) ?? [:]
                    print(self?.study)
                }
            } catch {
                logger.error("\(error)")
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
