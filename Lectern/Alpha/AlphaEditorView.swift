//
//  AlphaEditorView.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

struct AlphaEditorView: View {

    var vm = EditorViewModel()
    var cm = AlphaContentManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(cm.content) { block in
                AlphaTextBlock(block: block)
            }

            Spacer()
        }
        .padding()
        .onPreferenceChange(BlockSizePreference.self) {
            cm.sizes = $0
        }
        .environment(cm)
        .environment(vm)
    }
}

#Preview {
    AlphaEditorView()
}
