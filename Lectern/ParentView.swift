//
//  ParentView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

enum NavigationViewPages: String {
    case miscView
    case pdfView
}

struct ParentView: View {

    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) var colorScheme

    @State var cm = ContentManager()
    @State var vm = EditorViewModel()
    @State var nvm = NavigationViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Color.yellow
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipShape(Rectangle())
                    .overlay(
                        Color.black
                            .ignoresSafeArea()
                            .scrollTransition(axis: .vertical) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 0 : 1)
                            }
                            .allowsHitTesting(false)
                    )
                    .scrollTransition(axis: .vertical) { content, phase in
                        content
                            .offset(y: phase.isIdentity ? 0 : UIScreen.main.bounds.height/2)
                    }
                    .id(NavigationViewPages.miscView)


                mainView
                    .padding(.top, nvm.selectedPage == .miscView ? -55 : 0)
                    .background(Color.elevatedBackground)
                    .clipShape(RoundedRectangle(cornerRadius: nvm.selectedPage == .miscView ? 20 : UIConstants.screenRadius, style: .continuous))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
                    .animation(.smooth(duration: 0.39), value: nvm.selectedPage)
                    .scrollTransition(axis: .vertical) { content, phase in
                        content
                            .offset(y: phase.isIdentity ? 0 : -300)
                    }
                    .id(NavigationViewPages.pdfView)
                    .zIndex(99)
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $nvm.selectedPage)
        .scrollTargetBehavior(.paging)
        .defaultScrollAnchor(.bottom)
        .background(Color.elevatedBackground)
        .ignoresSafeArea()
    }

    var mainView: some View {
        TabView {
            ForEach(0..<3, id: \.self) { _ in
                EditorView()
                    .scrollDisabled(nvm.selectedPage == .miscView)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(
            SafeAreaBlockTop()
                .ignoresSafeArea()
            , alignment: .top
        )
        .overlay(
            NavigationBar(
                title: "SampleNote.pdf",
                minimized: (cm.focusState != nil) || !vm.selected.isEmpty || vm.shipState != nil
            )
            .opacity(nvm.showNoteSwitcher ? 0 : 1)
            .scaleEffect(nvm.showNoteSwitcher ? 0.7 : 1, anchor: .center)
            .animation(.snappy, value: cm.focusState)
            .padding(.top, safeAreaInsets.top)
            , alignment: .top
        )
        .overlay(
            CenterControl()
                .opacity(nvm.showNoteSwitcher ? 0 : 1)
                .scaleEffect(nvm.showNoteSwitcher ? 0.7 : 1, anchor: .center)
            , alignment: .bottom
        )
        .accentColor(.sub)
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea()
        .environment(cm)
        .environment(vm)
        .environment(nvm)
        .overlay(
            Color.white
                .opacity(0.0001)
                .frame(width: 30, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            , alignment: .leading
        )
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}
extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
