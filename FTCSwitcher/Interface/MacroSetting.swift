//
//  MacroSettingView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/23/23.
//

import SwiftUI

struct MacroSetting: View {
    @Binding var command: Command
    @ObservedObject var switcher: Switcher
    var label = ""
    
    var body: some View {
        HStack {
            if label != "" {
                TextField(label, value: $command.atem_macro, format: .number)
            } else {
                TextField("", value: $command.atem_macro, format: .number).labelsHidden()
            }
            Button("Run") {
                switcher.sendMacro(command.atem_macro)
            }
                .disabled(command.atem_macro == 0 || switcher.state == .disconnected)
        }
    }
}

//#Preview("FTC Switcher") {
//    MacroSetting("d1manualRunMacro", switcher: Switcher.get(division: 1), label: "Macro")
//}
