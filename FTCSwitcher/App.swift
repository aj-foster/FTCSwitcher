import Sparkle
import SwiftUI

@main
struct FTCSwitcherApp: App {
    @AppStorage("appUpdateBetaChannelEnabled") private var betaUpdatesEnabled = false;
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        #if DEBUG
            updaterController = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: Update(), userDriverDelegate: nil)
        #else
            updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: Update(), userDriverDelegate: nil)
        #endif
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
                Toggle("Enable Beta Updates", isOn: $betaUpdatesEnabled)
                Divider()
            }
        }
    }
}
