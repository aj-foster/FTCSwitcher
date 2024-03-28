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
        
        ProcessInfo.processInfo.beginActivity(options: .userInitiated, reason: "Timer-based Scoring Events")
    }
    
    var body: some Scene {
        DocumentGroup(newDocument: Division()) { file in
            DivisionView(division: file.$document)
                .frame(minWidth: 550)
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
