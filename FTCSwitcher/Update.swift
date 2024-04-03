import Sparkle

/**
 Delegate for the Sparkle auto-updater
 */
class Update: NSObject, SPUUpdaterDelegate {
    /**
     Use user preferences to determine whether Sparkle should check for beta channel updates
     */
    func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        if UserDefaults.standard.bool(forKey: "appUpdateBetaChannelEnabled") {
            return Set(["beta"])
        } else {
            return Set([])
        }
    }
}
