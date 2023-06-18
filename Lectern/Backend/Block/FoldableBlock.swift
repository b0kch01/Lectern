//
//  FoldableBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct FoldableBlock<Label, Content>: View where Label: View, Content: View {

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm

    @State var collapse = false

    var content: () -> Content
    var label: () -> Label

    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.content = content
        self.label = label
    }

    func toggleCollapse() {
        hideKeyboard()
        withAnimation(.defaultSpring) {
            collapse.toggle()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            label()

            HStack(spacing: 5) {
                ThreadLine(collapse: $collapse)
                    .padding(.top, 11)
                    .onTapGesture(perform: toggleCollapse)
                    .blur(radius: cm.studyState == .transcribing && vm.showAI ? 4 : 0)

                VStack(spacing: 3) {
                    if collapse {
                        CollapsedBlock {
                            Text(Dmy.loremS)
                        }
                        .onTapGesture(perform: toggleCollapse)
                    }

                    content()
                        .allowsHitTesting(!collapse)
                        .opacity(collapse ? 0 : 1)
                        .frame(maxHeight: collapse ? 0 : nil, alignment: .bottom)
                }
            }
        }
    }
}
