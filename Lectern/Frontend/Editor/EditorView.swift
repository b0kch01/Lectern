//
//  EditorView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct EditorView: View {

    @Environment(\.horizontalSizeClass) var sizeClass

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @GestureState private var isDragging = false

    @State private var offsetY: CGFloat = 0.0
    @State private var fake: CGFloat = 0.0

    var body: some View {
        ZStack(alignment: .top) {
            NoteSwitcherNavigationBar()

            EditorContent()
                .scaleEffect(nvm.showNoteSwitcher ? 0.7 : 1)
                .offset(y: offsetY)
                .onTapGesture {
                    if nvm.showNoteSwitcher {
                        withAnimation(.smooth(duration: 0.3), completionCriteria: .logicallyComplete) {
                            nvm.showNoteSwitcher = false
                            vm.shipState = nil
                        } completion: {
                            withAnimation {
                                nvm.roundCorners = false
                            }
                        }
                    }
                }
                .simultaneousGesture(nvm.showNoteSwitcher ? drag : nil)
                .edgesIgnoringSafeArea(.top)
                .transaction {
                    if $0.isContinuous {
                        $0.animation = .quickSpring
                    } else {
                        $0.animation = .smooth(duration: 0.3)
                    }
                }
        }
        .simultaneousGesture(nvm.showNoteSwitcher ? nil : fakeDrag)
    }


    private var fakeDrag: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { gesture in
                fake = gesture.translation.width
                fake = gesture.translation.height
            }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .updating($isDragging, body: { dragValue, state, transaction in
                transaction.isContinuous = true
                state = true
            })
            .onChanged { gesture in
                if gesture.translation.height < 0 {
                    offsetY = gesture.translation.height
                } else {
                    offsetY = sqrt(gesture.translation.height) * 9
                }
            }
            .onEnded { _ in
                offsetY = 0
            }
    }
}
