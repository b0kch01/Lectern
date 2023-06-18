//
//  NavigationViewModel.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

@Observable
class NavigationViewModel: ObservableObject {

    public var showNoteSwitcher = false
    public var roundCorners = false
}
