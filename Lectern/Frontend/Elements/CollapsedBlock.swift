//
//  CollapsedBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct CollapsedBlock <Content: View>: View {

    @Environment(EditorViewModel.self) var vm

    @GestureState private var offsetX: CGFloat = 0.0

    let id: String = UUID().uuidString

    let content: Content

    var selected: Bool {
        vm.selected.contains(id)
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            texCard
                .padding(.trailing, 16)

            content

            Spacer()
        }
        .padding(16)
        .background(Color.elevatedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .stroke(Color.borderBackground, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 1, y: 1)
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 11, style: .continuous))
        .padding(9)
        .overlay(Color.yellow.opacity(selected && !vm.selected.isEmpty ? 0.25 : 0))
        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 9, style: .continuous))
        .padding(.horizontal, -9)
        .contextMenu {
            Button { } label: {
                Text("Dashboard")
            }
        }
        .offset(x: offsetX)
        // .animation(.defaultSpring, value: offsetX)
        .highPriorityGesture(drag)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .updating($offsetX) { value, state, _ in
                state = sqrt(abs(value.translation.width)) * (value.translation.width < 0 ? -2.5 : 2.5)
            }
            .onEnded { _ in
                LightHaptics.shared.play(.rigid)

                withAnimation(.defaultSpring) {
                    if selected {
                        vm.selected.remove(id)
                    } else {
                        vm.selected.insert(id)
                    }
                }
            }
    }

    private var texCard: some View {
        Image(systemName: "ellipsis")
            .font(.system(size: UIConstants.callout).weight(.bold))
            .foregroundColor(Color(.tertiaryLabel))
            .frame(width: 35, height: 47)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.borderBackground, lineWidth: 1)
            )
    }
}
