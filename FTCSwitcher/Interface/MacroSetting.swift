//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    @Binding var setting: Int
    var switcher: Switcher
    
    var body: some View {
        HStack {
            TextField("", value: $setting, format: .number)
                .labelsHidden()
            Button("Run") {
                switcher.sendMacro(setting)
            }
                .disabled(setting == 0 || switcher.state == .disconnected)
        }
    }
}
