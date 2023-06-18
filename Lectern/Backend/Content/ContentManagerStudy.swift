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
        let url = URL(string: URL_K.blurt)!
        let req = URLRequest(url: url)

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: req)
                let gptResponse = try JSONDecoder().decode(GPTResponse.self, from: data)

                parseBlurt(gptResponse.content)
            } catch {
                logger.error("\(error)")
            }
        }
    }

    private func parseBlurt(_ content: String) -> [StudyFeedback] {
        var lines = content.components(separatedBy: "\n")
            lines = Array(lines[1..<lines.count-1])

        print(lines)

        return []
    }
}
