//
//  ImportControl.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI

struct ImportControl: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(\.colorScheme) var colorScheme

    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    @Binding var showImport: Bool
    @Binding var showScan: Bool
    @State private var text = ""
    @State private var error: Error?

    @ObservedObject var viewModel: ScanViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            GeometryReader { geometry in
                Color.clear.overlay(
                    VStack(spacing: 0) {
                        HStack(spacing: 7) {
                            Spacer()

                            Button(action: { showImport = true }) {
                                EmptySymbolButton(
                                    symbol: "folder.badge.plus",
                                    foreground: .primary.opacity(0.9),
                                    background: Color.clear
                                )
                            }
                            .fileImporter(isPresented: $showImport, allowedContentTypes: [.plainText]) { result in
                                switch result {
                                case .success(let url):
                                    // Ensure the URL is not accessed if the user has not granted permission.
                                    guard url.startAccessingSecurityScopedResource() else { return }

                                    // Read the file content
                                    do {
                                        text += try String(contentsOf: url)
                                    } catch {
                                        self.error = error
                                    }

                                    // Make sure you release the security-scoped resource when you finish.
                                    url.stopAccessingSecurityScopedResource()
                                case .failure(let error):
                                    self.error = error
                                }
                            }

                            Spacer()

                            Button(action: {
                                showScan = true
                            }) {
                                EmptySymbolButton(
                                    symbol: "doc.viewfinder",
                                    foreground: vm.showScan ? .mainColorInvert : .primary.opacity(0.9),
                                    background: vm.showScan ? .main : Color.clear
                                )
                            }
                            .sheet(isPresented: $showScan) {
                                DocumentCameraViewControllerWrapper(viewModel: viewModel)
                                    .ignoresSafeArea()
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .foregroundStyle(.primary.opacity(0.9))
                        .padding(.top, 9)
                        .padding(.bottom, 16)
                    }
                    .frame(width: sizeClass == .compact ? geometry.size.width : geometry.size.width/1.6)
                    , alignment: .bottom
                )
            }
            .frame(height: 74)
            .padding(.bottom, safeAreaInsets.bottom)
            .background(SafeAreaBlockBottom().ignoresSafeArea())
        }
    }
}

struct DocumentCameraViewControllerWrapper: UIViewControllerRepresentable {
    var viewModel: ScanViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        return viewModel.getDocumentCameraViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}
