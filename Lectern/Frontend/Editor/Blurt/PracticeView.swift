//
//  PracticeView.swift
//  Lectern
//
//  Created by Nathan Choi on 6/18/23.
//

import SwiftUI

struct PracticeView: View {

    @Environment(ContentManager.self) var cm

    var questions: [String] {
        Array(cm.questions.keys).sorted()
    }

    var body: some View {
        ForEach(questions, id:\.self) { question in
            if let question = cm.questions[question] {
                Button(action: {
                    cm.studyState = .practicing
                }) {
                    VStack {
                        Text("Understading: " + String(question.understanding))
                        Text("Question: " + question.question)
                    }
                    
                }

            }
        }
    }
}
