import Foundation
import os

class ATEM: ObservableObject {
    // MARK: Static interface
    
    static private var registry: [UUID : ATEM] = [:]
    
    /**
     Get the ATEM switcher instance associated with the given division
     
     If no ATEM switcher instance exists for the division, a new one is created. Note that creating
     an instance does not automatically discover or connect a switcher, but it should be safely
     removed with the static `remove` function when a division closes.
     */
    static func get(_ division_id: UUID) -> ATEM {
        if let switcher = registry[division_id] {
            return switcher
        } else {
            let switcher = ATEM(division_id)
            registry[division_id] = switcher
            return switcher
        }
    }
    
    /**
     Disconnect the ATEM switcher instance associated with the given division ID and remove it from
     the registry
     
     Any future attempts to `get` the switcher instance will result in a new instance.
     */
    static func remove(_ division_id: UUID) {
        if let switcher = registry[division_id] {
            switcher.disconnect()
            registry.removeValue(forKey: division_id)
        }
    }
    
    // MARK: Connection status
    
    @Published var error: String?
    @Published var state: ATEM.State = .disconnected
    
    // MARK: Connection management

    private var division_id: UUID
    private var switcher: OpaquePointer?
    
    private init(_ division_id: UUID) {
        self.division_id = division_id
    }
    
    /**
     Discover and connect to an ATEM switcher on the network or via USB
     
     Hostnames should be IP addresses or valid local hostnames, or an empty string to connect to a
     local switcher via USB. It is recommended to use the network when possible due to contention
     for USB devices with other applications (ex. the ATEM Switcher application).
     */
    func connect(_ host: String) {
        error = nil
        let target = if host == "" { "USB" } else { host }
        Log("Connect to ATEM \(target)", tag: "Switcher \(division_id)")
        
        var failureReason : BMDSwitcherConnectToFailure = 0
        switcher = connectSwitcher(host as CFString, &failureReason)
        
        switch failureReason {
        case 0:
            break
        case bmdSwitcherConnectToFailureNoResponse.rawValue:
            error = "No response from switcher"
        case bmdSwitcherConnectToFailureIncompatibleFirmware.rawValue:
            error = "Incompatible switcher firmware"
        case bmdSwitcherConnectToFailureCorruptData.rawValue:
            error = "Corrupt data received"
        case bmdSwitcherConnectToFailureStateSync.rawValue:
            error = "Failure during state sync"
        case bmdSwitcherConnectToFailureStateSyncTimedOut.rawValue:
            error = "Timeout during state sync"
        default:
            error = "Unknown error (\(failureReason))"
        }
        
        if let error {
            Log("Error during connection to switcher: \(error)", tag: "Switcher \(division_id)")
        }
        
        if switcher != nil {
            state = .connected
        } else {
            state = .disconnected
        }
    }
    
    /**
     Disconnect from the ATEM switcher
     */
    func disconnect() {
        error = nil
        Log("Disconnect", tag: "Switcher \(division_id)")
        
        if switcher != nil {
            disconnectSwitcher(switcher)
            switcher = nil
            state = .disconnected
        }
    }
    
    enum State {
        case disconnected
        case connected
    }
    
    // MARK: Macros
    
    /**
     Send a numbered macro to the ATEM switcher, if connected
     
     The macro is ignored if it is out-of-bounds (non-positive) or if the switcher is disconnected.
     Macros given to this function should be 1-based, and they will be converted to 0-based indexes
     prior to sending to the switcher.
     */
    func sendMacro(_ macro: Int) {
        guard macro != 0 else { return }
        guard switcher != nil && state == .connected else {
            Log("Intended to send macro \(macro) but switcher is disconnected", tag: "Switcher \(division_id)")
            return
        }
        
        Log("Sending macro \(macro)", tag: "Switcher \(division_id)")
        sendMacroToSwitcher(switcher, Int32(macro - 1))
    }
}
