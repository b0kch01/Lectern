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

    @State var vm = EditorViewModel()
    @State var nvm = NavigationViewModel()

    @State var showImport = false
    @State var showScan = false

    @State private var currentPageIndex: Int = 0

    @Namespace var bottomID

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ListView()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(Color.darkBackground)
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
                    .clipShape(RoundedRectangle(cornerRadius: showImport || showScan ? 0 : (nvm.selectedPage == .miscView ? 20 : UIConstants.screenRadius), style: .continuous))
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
                    ForEach(0..<vm.numberOfTabs + 1, id: \.self) { index in
                        Group {
                            if index < vm.numberOfTabs {
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
            .scrollPosition(id: $vm.scrolledID)
            .onChange(of: vm.importPDF) {
                withAnimation {
                    proxy.scrollTo(bottomID, anchor: .trailing)
                    vm.scrolledID = vm.numberOfTabs
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
                minimized: nvm.selectedPage == .miscView ? false : (!vm.selected.isEmpty || vm.shipState != nil)
            )
            .padding(.top, safeAreaInsets.top)
            , alignment: .top
        )
        .overlay(
            CenterControl()
                .opacity((vm.scrolledID ?? -1) == vm.numberOfTabs ? 0 : 1)
                .scaleEffect((vm.scrolledID ?? -1) == vm.numberOfTabs ? 0.7 : 1, anchor: .bottom)
                .blur(radius: (vm.scrolledID ?? -1) == vm.numberOfTabs ? 5 : 0)
                .animation(.smooth(duration: 0.2), value: vm.scrolledID)
            , alignment: .bottom
        )
        .overlay(
            ImportControl(showImport: $showImport, showScan: $showScan, viewModel: ScanViewModel())
                .opacity((vm.scrolledID ?? -1) != vm.numberOfTabs ? 0 : 1)
                .scaleEffect((vm.scrolledID ?? -1) != vm.numberOfTabs ? 0.7 : 1, anchor: .bottom)
                .blur(radius: (vm.scrolledID ?? -1) != vm.numberOfTabs ? 5 : 0)
                .animation(.smooth(duration: 0.2), value: vm.scrolledID)
            , alignment: .bottom
        )
        .accentColor(.sub)
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea()
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
