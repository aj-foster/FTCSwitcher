//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    @ObservedObject var switcher: Switcher
    @State var setting: String
    @AppStorage private var value: Int
    var label: String
    
    init(_ setting: String, switcher: Switcher, label: String = "") {
        self.setting = setting
        self.switcher = switcher
        self.label = label
        self._value = AppStorage(wrappedValue: 0, setting)
    }
    
    var body: some View {
        HStack {
            if label != "" {
                TextField(label, value: $value, format: .number)
            } else {
                TextField("", value: $value, format: .number).labelsHidden()
            }
            Button("Run") {
                switcher.sendMacro(value)
            }
                .disabled(value == 0 || switcher.state == .disconnected)
        }
    }
}

#Preview("FTC Switcher") {
    MacroSetting("d1manualRunMacro", switcher: Switcher.get(division: 1), label: "Macro")
}
