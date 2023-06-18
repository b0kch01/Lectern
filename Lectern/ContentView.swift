//
//  ContentView.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI
import OSLog

let logger = Logger()

struct ContentView: View {

    @State var nvm = NavigationViewModel()

    var body: some View {
        ParentView()
            .environment(nvm)
    }
}
