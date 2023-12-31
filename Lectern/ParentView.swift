//
//  ParentView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct ParentView: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) var colorScheme

    @State var cm = ContentManager()
    @State var vm = EditorViewModel()
    @State var nvm = NavigationViewModel()

    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { _ in
                EditorView()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.container)
        .overlay(
            VStack {
                NoteSafeAreaBlock()
                Spacer()
            }
            .opacity(nvm.showNoteSwitcher ? 1 : 0)
            .ignoresSafeArea()
        )
        .overlay(
            NavigationBar(
                title: "Getting Started on Lectern",
                minimized: (cm.focusState != nil) || !vm.selected.isEmpty || vm.shipState != nil
            )
            .opacity(nvm.showNoteSwitcher ? 0 : 1)
            .scaleEffect(nvm.showNoteSwitcher ? 0.7 : 1, anchor: .center)
            .animation(.snappy, value: cm.focusState)
            , alignment: .top
        )
        .overlay(
            CenterControl()
                .opacity(nvm.showNoteSwitcher ? 0 : 1)
                .scaleEffect(nvm.showNoteSwitcher ? 0.7 : 1, anchor: .center)
            , alignment: .bottom
        )
        .background(Color.elevatedBackground.ignoresSafeArea().opacity(!nvm.roundCorners ? 1 : 0))
        .background(Color.black.ignoresSafeArea().opacity(nvm.roundCorners ? 1 : 0))
        .accentColor(.sub)
        .scrollDismissesKeyboard(.interactively)
        .environment(cm)
        .environment(vm)
        .environment(nvm)
    }
}
