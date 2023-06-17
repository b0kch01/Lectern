//
//  LecternTextReveal.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

struct LecternTextReveal: View {

    @State var show = false

    var word: String

    init(word: String) {
        self.word = word + " "
    }

    var body: some View {
        Text(word)
            .opacity(0)
            .overlay (
                HStack(spacing: 0) {
                    ForEach(0..<word.count, id:\.self) { i in
                        Text(String(word[i]))
                            .padding(.horizontal, -0.1)
                            .padding(.leading, show ? -0.1 : -5)
                            .opacity(show ? 1 : 0)
                            .scaleEffect(show ? 1 : 0.7, anchor: .bottomLeading)
                            .animation(.spring.delay(Double(i) * 0.015), value: show)
                    }
                },

                alignment: .center
            )
            .onAppear {
                show.toggle()
            }

    }
}

#Preview {
    LecternTextReveal(word: "Anticipation")
}
