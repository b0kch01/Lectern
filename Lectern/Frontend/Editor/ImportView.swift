//
//  ImportView.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FullScreenCoverView: View {
    @Binding var text: String
    @Binding var error: Error?
    @Binding var isPresented: Bool

    var body: some View {
        Button("Import File") {
            // Trigger file import here
        }
        .fileImporter(isPresented: $isPresented, allowedContentTypes: [.plainText]) { result in
            switch result {
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else { return }
                do {
                    text += try String(contentsOf: url)
                } catch {
                    self.error = error
                }
                url.stopAccessingSecurityScopedResource()
            case .failure(let error):
                self.error = error
            }
        }
    }
}
