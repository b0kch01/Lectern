//
//  ContentManagerStudy.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI
import Observation

struct GPTResponse: Codable {
    let role: String
    let content: String
}

struct StudyFeedback: Codable {
    let id: String
    let feedback: String
}


class StudyQuestion: Identifiable, Codable {
    let id: String = UUID().uuidString
    
    var role: String = ""
    var content: String = ""

    init(role: String, content: String) {
        self.content = content
        self.role = role
    }
}



extension ContentManager {

    func practice() {
        withAnimation(.snappy) {
            studyState = .practicing
        }

        if contentTree["root"]?.children?.contains(studySelect ?? "") != true {
            withAnimation(.snappy) {
                studySelect = contentTree["root"]?.children?.first(where: { contentTree[$0]?.children?.contains(studySelect ?? "") == true })
            }
        }

        let url = URL(string: URL_K.practice)!

        Task {
            var req = URLRequest(url: url)

//            NOTES
//            {{Heading: Mexican Immigrant's Intergenerational Mobility}}
//            {{ZZ3: Mexicans/Mexican Americans drastically changed in graduate numbers.}}
//            {{ACF: Chinese have the highest educational outcomes but have virtually no intergenerational gains.}}
//            END NOTES
//
//            TRANSCRIPT
//            More Mexican immigrants are now graduating compared to before.
//            END TRANSCRIPT
//
//            FEEDBACK
//            ZZ3: Include the specific detail that the number of graduates among Mexicans/Mexican Americans has drastically changed.
//            ACF: Don't forget to mention the comparison with Chinese immigrants, specifically noting that although they
//                 have the highest educational outcomes, their intergenerational mobility hasn't improved significantly.
//            END FEEDBACK


            var context = "NOTES\n" + getNotes()
                .components(separatedBy: "\n").map({ "{{\($0)}}" })
                .joined(separator: "\n") + "\nEND NOTES\n\n"

            context += "TRANSCRIPT\n" + blurtVM.savedText.joined(separator: " ") + "\nEND TRANSCRIPT\n\n"

            let list: [String] = Array(study.values.map { "\($0.id): \($0.feedback)" })
            let feedback = "FEEDBACK\n\(list.joined(separator: "\n"))\nEND FEEDBACK"
            context += feedback

            req.setValue(context.replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "context")

            if questions.last?.role == "assistant" {
                questions.append(StudyQuestion(role: "user", content: blurtVM.savedText.joined(separator: " ")))
            }

            let chatHistory = "[" + questions
                .map { "{\"role\": \"\($0.role)\", \"\($0.content)\"}" }
                .joined(separator: ",") + "]"


            req.setValue(chatHistory.replacingOccurrences(of: "\n", with: "\\n"), forHTTPHeaderField: "chatHistory")

            do {
                let (data, _) = try await URLSession.shared.data(for: req)

                DispatchQueue.main.async { [weak self] in
                    self?.parsePractice(data)
                    self?.studyState = .idle
                }
            } catch {
                print(error)
                studyState = .idle
            }
        }
    }

    private func parsePractice(_ content: Data) {
        logger.notice("Parsing practice: \(content)")
        guard let obj = try? JSONDecoder().decode(StudyQuestion.self, from: content) else { return }
        questions.append(obj)
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
                print(String(data: data, encoding: .utf8)!)

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

        let output = lines.reduce(into: [String: StudyFeedback]()) {
            let parts = $1.split(separator: ": ", maxSplits: 1)
            if parts.count == 2 {
                let id = String(parts[0])
                let feedback = String(parts[1])
                
                $0[id] = StudyFeedback(id: id, feedback: feedback)
            }
        }

        if output.count == 0 {
            var dict = [String: StudyFeedback]()
            dict[studySelect ?? "..."] = StudyFeedback(id: studySelect ?? "...", feedback: content)
            return dict
        } else {
            return output
        }
    }
}
