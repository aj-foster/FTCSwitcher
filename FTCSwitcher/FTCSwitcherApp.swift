//
//  FTCSwitcherApp.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/3/23.
//

import Sparkle
import SwiftUI

@main
struct FTCSwitcherApp: App {
//    private let updaterController: SPUStandardUpdaterController
    
//    init() {
//        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(scoring: Scoring.current, switcher: Switcher.current)
        }
    }
}
