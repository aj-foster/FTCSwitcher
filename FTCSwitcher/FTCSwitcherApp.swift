//
//  FTCSwitcherApp.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/3/23.
//

import SwiftUI
import os

@main
struct FTCSwitcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(scoring: Scoring.current, switcher: Switcher.current)
        }
    }
}
