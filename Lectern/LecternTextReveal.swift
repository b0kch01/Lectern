//
//  LecternTextReveal.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

struct LecternTextReveal: View {

    @State var show = false


    let word: String

    var body: some View {
        VStack {
            Text(word)
                .opacity(0)
                .overlay (
                    HStack(spacing: 0) {
                        ForEach(0..<word.count, id:\.self) { i in
                            Text(String(word[i]))
                                .padding(.horizontal, -0.1)
                                .scaleEffect(show ? 1 : 0.5, anchor: .bottomLeading)
                        }
                    },

                    alignment: .center
                )

            Button("TOGGLE") {
                try? await Task.sleep(nanoseconds: UInt64(0.5) * 1_000_000_000)
            }
        }
    }
}

#Preview {
    LecternTextReveal(word: "Anticipation")
}
