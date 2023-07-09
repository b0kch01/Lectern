//
//  StudyControl.swift
//  Lectern
//
//  Created by Paul Wong on 7/9/23.
//

import SwiftUI

struct StudyControl: View {

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @State var bounced = true
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 5) {
            SymbolButton(symbol: "ellipsis") { }
                .opacity(0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    Group {
                        SymbolButton(
                            symbol: "waveform",
                            foreground: vm.showAI ? .mainColorInvert : .primary.opacity(0.9),
                            background: vm.showAI ? .main : Color.clear
                        ) {
                            withAnimation(.defaultSpring) {
                                vm.showAI.toggle()
                            }

                            if vm.showAI {

                            } else {
                                cm.studySelect = nil
                            }
                        }
                        .symbolEffect(.bounce, value: vm.showAI ? bounced : false)
                        .onReceive(timer) { _ in
                            bounced.toggle()
                        }

                        SymbolButton(symbol: "menucard.fill")

                        SymbolButton(symbol: "checklist")
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.1)
            ]), startPoint: .leading, endPoint: .trailing))
        }
    }
}
