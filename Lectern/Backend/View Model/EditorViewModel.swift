//
//  EditorViewModel.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

@Observable
final class EditorViewModel {

    var tunnelVision = false

    var isEditing = false
    var isTitleEditing = false

    // Editor Island states
    var shipState: ShipState? = nil

    var selected = Set<String>()

    var showAI = false

    // Import controls
    var showScan = false

    var importPDF = false

    var scrolledID: Int?

    var numberOfTabs = 4
}

class ViewModel: ObservableObject {
    @Published var showFile: Bool = false
}

enum ShipState: String {
    case add
    case format
    case misc
    case study
}
