//
//  NoteNavigationBar.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct NoteSwitcherNavigationBar: View {

    @Environment(NavigationViewModel.self) var nvm

    @State var noteTitle: String = "Getting Started on Lectern"

    var body: some View {
        Group {
            if nvm.showNoteSwitcher {
                VStack(spacing: 0) {
                    CenterHStack {
                        TextField(
                            "Untitled Note",
                            text: $noteTitle
                        )
                        .font(.system(size: UIConstants.callout).weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.horizontal)
                        .submitLabel(.done)
                    }
                    .padding()

                    Spacer()
                }
                .transition(.opacity)
            }
        }
    }
}
