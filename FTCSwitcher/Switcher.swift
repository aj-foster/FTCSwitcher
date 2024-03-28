//
//  Switcher.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/15/23.
//

import Foundation
import os

class Switcher: ObservableObject {
    var division: Division
    @Published var error: String?
    @Published var state: Switcher.State = .disconnected
    var switcher: OpaquePointer?
    
    static private var registry: [UUID : Switcher] = [:]
    static func get(_ division: Division) -> Switcher {
        if let switcher = registry[division.id] {
            return switcher
        } else {
            let switcher = Switcher(division)
            registry[division.id] = switcher
            return switcher
        }
    }
    
    static func remove(_ division: UUID) {
        if let scoring = registry[division] {
            scoring.disconnect()
            registry.removeValue(forKey: division)
        }
    }
    
    init(_ division: Division) {
        self.division = division
    }
    
    func connect(_ url: String) {
        error = nil
        let target = if url == "" { "USB" } else { url }
        Log("Connect to \(target)", tag: "Switcher \(division)")
        
        var failureReason : BMDSwitcherConnectToFailure = 0
        switcher = connectSwitcher(url as CFString, &failureReason)
        
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
            Log("Error during connection to switcher: \(error)", tag: "Switcher \(division)")
        }
        
        if switcher != nil {
            state = .connected
        } else {
            state = .disconnected
        }
    }
    
    func sendMacro(_ macro: Int) {
        guard macro != 0 else { return }
        guard switcher != nil && state == .connected else { Log("Intended to send macro \(macro) but switcher is disconnected", tag: "Switcher \(division)"); return }
        
        Log("Sending macro \(macro)", tag: "Switcher \(division)")
        sendMacroToSwitcher(switcher, Int32(macro - 1))
    }
    
    func disconnect() {
        error = nil
        Log("Disconnect", tag: "Switcher \(division)")
        
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
}
