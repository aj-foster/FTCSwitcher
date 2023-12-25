//
//  FTCSwitcherApp.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/3/23.
//

import SwiftUI

@main
struct FTCSwitcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(scoring: Scoring.current, switcher: Switcher.current)
        }
    }
}
