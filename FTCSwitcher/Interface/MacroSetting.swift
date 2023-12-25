//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    @State var macroValue: Int
    
    var body: some View {
        HStack {
            TextField("", value: $macroValue, format: .number)
                .labelsHidden()
//                .frame(width: 40)
            Button("Run") {
                Switcher.current.sendMacro(macroValue)
            }
                .disabled(macroValue == 0 || Switcher.current.state == .disconnected)
        }
    }
}
