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

    var showNotes = false
    var showNotesAnimate = false

    var showTOB = false
    var TOBisTrailing = false

    // Editor Island states
    var shipState: ShipState? = nil

    // Slash Menu
    var showAssistant = false
    var showSlash = false

    var isTrailing = true
    var startFlashcard = false

    var selected = Set<String>()

    // Study
    var blurFlashcard = false

    var showAllNotes = false

    var showAI = false
}

enum ShipState: String {
    case add
    case format
    case misc
}
