//
//  TextBlock.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

struct TextBlock: View {

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm

    var block: Block

    @State private var height: CGFloat = 0.0

    @GestureState private var offsetX: CGFloat = 0.0

    @State private var fakeOffsetX: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    @State private var swipeSnap = false

    var newLineAction: ((NSRange) -> Void)? = nil
    var deleteAction: (() -> Void)? = nil
    var selected: Bool {
        vm.selected.contains(block.id)
    }
    var studySelected: Bool {
        cm.studySelect == block.id
    }

    init(
        _ block: Block,
        newLineAction: ((NSRange) -> Void)?=nil,
        deleteAction: (() -> Void)?=nil
    ) {
        self.block = block
        self.newLineAction = newLineAction
        self.deleteAction = deleteAction
    }

    var body: some View {
        TextBlockUIKit(
            block: block,
            cm: cm,
            focus: Binding(get: { cm.focusState == block.id }, set: { cm.focusState = $0 ? block.id : nil }),
            height: $height,
            disabled: !vm.selected.isEmpty,
            newLineAction: newLineAction,
            deleteAction: deleteAction
        )
        .contentShape(Rectangle())
        .padding(.vertical, 1)
        .overlay(studySelectionOverlay)
        .overlay(selectionOverlay)
        .offset(x: offsetX)
        .simultaneousGesture(tapGesture)
        //.highPriorityGesture(dragGesture)
        .onChange(of: swipeSnap) {
            LightHaptics.shared.play(.soft)
        }
        .overlay(deletionIndicator, alignment: .trailing)
        .offset(y: -5)
        .blur(radius: cm.studyState == .transcribing && vm.showAI && !studySelected ? 5 : 0)
        .disabled(vm.showAI)
    }

    var selectionOverlay: some View {
        Color.cyan.opacity(selected ? 0.25 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            .padding(.horizontal, -10)
            .padding(.top, (block.textType == .body || block.textType == .header) ? 5 : 0)
            .allowsHitTesting(selected)
    }

    var studySelectionOverlay: some View {
        Color.yellow.opacity(studySelected ? 0.25 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            .padding(.horizontal, -10)
            .padding(.top, (block.textType == .body || block.textType == .header) ? 5 : 0)
            .allowsHitTesting(studySelected)
    }

    var tapGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                if !vm.selected.isEmpty {
                    LightHaptics.shared.play(.rigid)

                    withAnimation(.defaultSpring) {
                        if selected {
                            vm.selected.remove(block.id)
                        } else {
                            vm.selected.insert(block.id)
                        }
                    }
                }
            }
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .updating($offsetX) { value, state, transaction in
                transaction.isContinuous = true

                if value.translation.width > 0 {
                    state = sqrt(abs(value.translation.width)) * 2.5
                } else {
                    state = value.translation.width
                }
            }
            .onChanged { gesture in
                fakeOffsetX = gesture.translation.width
                velocity = gesture.predictedEndTranslation.height - gesture.translation.height
                swipeSnap = fakeOffsetX < -120
            }
            .onEnded { _ in
                if fakeOffsetX > 0 {
                    LightHaptics.shared.play(.rigid)

                    withAnimation(.defaultSpring) {
                        if selected {
                            vm.selected.remove(block.id)
                        } else {
                            vm.selected.insert(block.id)
                        }
                    }
                } else {
                    withAnimation(.defaultSpring) {
                        if !vm.selected.isEmpty {
                            vm.selected.remove(block.id)
                        }
                    }
                }

                withAnimation(.defaultSpring) {
                    fakeOffsetX = 0

                    if swipeSnap {
                        cm.removeBlock(targetId: block.id)
                    }

                    swipeSnap = false
                }
            }
    }

    var deletionIndicator: some View {
        CenterStack {
            Image(systemName: "trash.fill")
                .foregroundStyle(swipeSnap ? .red : .primary.opacity(0.5))
                .font(.system(size: UIConstants.title3).weight(.medium))
        }
        .frame(width: max(0, -offsetX - 18), alignment: .trailing)
        .opacity(min(1, -offsetX/100))
        .blur(radius: min(5, (5 - (offsetX / -20))))
        .padding(.bottom, 5)
        .padding(.vertical, 9)
        .padding(.leading, 16)
        .offset(y: 6)
    }
}
