//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    @State var setting: String
    @AppStorage private var value: Int
    
    init(_ setting: String) {
        self.setting = setting
        self._value = AppStorage(wrappedValue: 0, setting)
    }
    
    var body: some View {
        HStack {
            TextField("", value: $value, format: .number)
                .labelsHidden()
            Button("Run") {
                Switcher.current.sendMacro(value)
            }
                .disabled(value == 0 || Switcher.current.state == .disconnected)
        }
    }
}
