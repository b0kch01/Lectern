//
//  BlurtView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct BlurtView: View {

    let textArray = [
        "風に乗って流れる 私達の今は",
        "どんな国 どんな世界へ行けるんだろう",
        "メロディの産声に 歓喜して感極まって",
        "明けては暮れてゆく 小さな毎日"
    ]

    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 30) {
            ForEach(textArray, id: \.self) { text in
                Text(text)
                    .foregroundColor(.primary.opacity(text == textArray.last ? 1.0 : 0.5))
                    .scrollTransition(axis: .vertical) { content, phase in
                        content
                            .blur(radius: phase.isIdentity ? 0 : 2)
                            .opacity(phase.isIdentity ? 1 : 0.5)
                    }
            }

            Image(systemName: "waveform")
                .font(.largeTitle.weight(.semibold))
                .foregroundColor(.primary)
                .symbolEffect(.pulse)
                .symbolEffect(.bounce, value: bounced)
                .opacity(0.9)
                .padding(.top, 10)

            Spacer()
        }
        .font(.title.weight(.semibold))
        .padding(.top)
        .padding(.trailing, 30)
        .onReceive(timer) { _ in
            bounced.toggle()
        }
    }
}
