import Sparkle
import SwiftUI

@main
struct FTCSwitcherApp: App {
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        #if DEBUG
            updaterController = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil)
        #else
            updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        #endif
    }
    
    var body: some Scene {
        Window("FTC Switcher", id: "ftc-switcher") {
            ContentView()
        }
        .commands {
            CommandGroup(before: .appTermination) {
                Button("Check for Updates...") {
                    Log("User-initiated update check", tag: "App")
                    updaterController.checkForUpdates(self)
                }
            }
        }
    }
}
