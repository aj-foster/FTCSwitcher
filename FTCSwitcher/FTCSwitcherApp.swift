//
//  FTCSwitcherApp.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/3/23.
//

import Sparkle
import SwiftData
import SwiftUI

@main
struct FTCSwitcherApp: App {
//    private let updaterController: SPUStandardUpdaterController
    
    init() {
//        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        Window("FTC Switcher", id: "ftc-switcher") {
            ContentView()
                .modelContainer(for: Division.self)
        }
    }
}
