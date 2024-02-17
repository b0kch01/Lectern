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

    @State private var currentPageIndex: Int = 0

    @Namespace var bottomID
    @State var scrolledID: Int?

    let numberOfTabs = 4

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ListView()
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
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: nvm.selectedPage == .miscView ? 20 : UIConstants.screenRadius, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 30, y: 10)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
                    .animation(.smooth(duration: 0.39), value: nvm.selectedPage)
                    .scrollTransition(axis: .vertical) { content, phase in
                        content
                            .offset(y: phase.isIdentity ? 0 : -120)
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
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<numberOfTabs + 1, id: \.self) { index in
                        Group {
                            if index < numberOfTabs {
                                ZStack {
                                    EditorView()
                                    StudyView()
                                }
                                .scrollDisabled(nvm.selectedPage == .miscView)
                                .frame(width: UIScreen.main.bounds.width)
                                .tag(index)
                                .id(index)
                            } else {
                                PlaceholderView()
                                    .id(bottomID)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .tag(index)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledID)
            .onChange(of: vm.importPDF) {
                withAnimation {
                    proxy.scrollTo(bottomID, anchor: .trailing)
                    scrolledID = numberOfTabs
                }
            }
        }
        .opacity(nvm.selectedPage == .miscView ? 0 : 1)
        .overlay(
            SafeAreaBlockTop()
                .ignoresSafeArea()
                .opacity(nvm.selectedPage == .miscView ? 0 : 1)
            , alignment: .top
        )
        .overlay(
            NavigationBar(
                title: "SampleNote.pdf",
                minimized: nvm.selectedPage == .miscView ? false : ((cm.focusState != nil) || !vm.selected.isEmpty || vm.shipState != nil)
            )
            .animation(.snappy, value: cm.focusState)
            .padding(.top, safeAreaInsets.top)
            , alignment: .top
        )
        .overlay(
            CenterControl()
                .opacity((scrolledID ?? -1) == numberOfTabs ? 0 : 1)
                .scaleEffect((scrolledID ?? -1) == numberOfTabs ? 0.7 : 1, anchor: .bottom)
                .blur(radius: (scrolledID ?? -1) == numberOfTabs ? 5 : 0)
                .animation(.smooth(duration: 0.2), value: scrolledID)
            , alignment: .bottom
        )
        .overlay(
            ImportControl()
                .opacity((scrolledID ?? -1) != numberOfTabs ? 0 : 1)
                .scaleEffect((scrolledID ?? -1) != numberOfTabs ? 0.7 : 1, anchor: .bottom)
                .blur(radius: (scrolledID ?? -1) != numberOfTabs ? 5 : 0)
                .animation(.smooth(duration: 0.2), value: scrolledID)
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
