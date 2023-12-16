//
//  Preferences.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/15/23.
//

import Foundation

enum Preferences {
    func getMacro(name key: String) {
        UserDefaults.standard.integer(forKey: key)
    }
    
    func setMacro(macro value: Int, name key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
