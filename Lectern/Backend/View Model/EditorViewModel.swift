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
    var showStudy = false

    // Editor Island states
    var shipState: ShipState? = nil

    var selected = Set<String>()

    var showAI = false
}

enum ShipState: String {
    case add
    case format
    case misc
}
