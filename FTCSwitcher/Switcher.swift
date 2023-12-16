//
//  Switcher.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/15/23.
//

import Foundation
import os

class Switcher: ObservableObject {
    @Published var state: SwitcherState = .disconnected
    var switcher: OpaquePointer?
    
    static let current = Switcher()
    
    func connect(_ url: String) {
        switcher = connectSwitcher(url as CFString)
        
        if switcher != nil {
            state = .connected
        } else {
            state = .disconnected
        }
    }
    
    func sendMacro(_ macro: Int) {
        os_log("Sending macro \(macro)")

        if macro != 0 && switcher != nil {
            sendMacroToSwitcher(switcher, Int32(macro))
        }
    }
}

enum SwitcherState {
    case disconnected
    case connected
}
