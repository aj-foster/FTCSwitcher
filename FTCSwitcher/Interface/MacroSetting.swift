//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    var switcher: Switcher
    @State var setting: String
    @AppStorage private var value: Int
    
    init(_ setting: String, switcher: Switcher) {
        self.switcher = switcher
        self.setting = setting
        self._value = AppStorage(wrappedValue: 0, setting)
    }
    
    var body: some View {
        HStack {
            TextField("", value: $value, format: .number)
                .labelsHidden()
            Button("Run") {
                switcher.sendMacro(value)
            }
                .disabled(value == 0 || switcher.state == .disconnected)
        }
    }
}
