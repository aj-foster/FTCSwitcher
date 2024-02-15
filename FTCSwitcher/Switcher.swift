//
//  Switcher.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/15/23.
//

import Foundation
import os

class Switcher: ObservableObject {
    private static var divisions: [Switcher] = []
    static func division(_ division: Int) -> Switcher {
        if divisions.count < division {
            for i in (divisions.count...division) {
                divisions.append(Switcher())
            }
        }
        return divisions[division]
    }

    @Published var error: String?
    @Published var state: Switcher.State = .disconnected
    var switcher: OpaquePointer?
    
    func connect(_ url: String) {
        error = nil
        let target = if url == "" { "USB" } else { url }
        Log("Connect to \(target)", tag: "Switcher")
        
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
        
        if switcher != nil {
            state = .connected
        } else {
            state = .disconnected
        }
    }
    
    func sendMacro(_ macro: Int) {
        guard macro != 0 else { return }
        guard switcher != nil && state == .connected else { Log("Intended to send macro \(macro) but switcher is disconnected"); return }
        
        Log("Sending macro \(macro)", tag: "Switcher")
        sendMacroToSwitcher(switcher, Int32(macro - 1))
    }
    
    func disconnect() {
        error = nil
        Log("Disconnect", tag: "Switcher")
        
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
