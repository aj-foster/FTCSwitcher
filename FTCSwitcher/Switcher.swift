//
//  Switcher.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/15/23.
//

import Foundation
import os

class Switcher: ObservableObject {
    @Published var state: Switcher.State = .disconnected
    var switcher: OpaquePointer?
    
    static let current = Switcher()
    
    func connect(_ url: String) {
        Log("Connect", tag: "Switcher")
        switcher = connectSwitcher(url as CFString)
        
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
        Log("Disconnect", tag: "Switcher")
        
        if switcher != nil {
            disconnectSwitcher(switcher)
            state = .disconnected
        }
    }
    
    enum State {
        case disconnected
        case connected
    }
}
