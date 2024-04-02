import SwiftUI

struct MacroSetting: View {
    @Binding var command: Command
    @Binding var division: Division
    var label = ""
    
    @EnvironmentObject private var atem_switcher: ATEM
    @EnvironmentObject private var companion_switcher: Companion
    
    var body: some View {
        if division.switcher_settings.type == .atem {
            atem
        } else {
           companion
        }
    }
    
    var atem: some View {
        HStack {
            if label != "" {
                TextField(label, value: $command.atem_macro, format: .number)
            } else {
                TextField("", value: $command.atem_macro, format: .number).labelsHidden()
            }
            
            Button("Run") {
                atem_switcher.sendMacro(command.atem_macro)
            }
                .disabled(command.atem_macro == 0 || atem_switcher.state == .disconnected)
        }
    }
    
    var companion: some View {
        HStack {
            if label != "" {
                TextField(label, value: $command.companion_page, format: .number)
            } else {
                TextField("", value: $command.companion_page, format: .number).labelsHidden()
            }
            TextField("", value: $command.companion_row, format: .number).labelsHidden()
            TextField("", value: $command.companion_col, format: .number).labelsHidden()
            Button("Run") {
                companion_switcher.sendMacro(command.companion_page, command.companion_row, command.companion_col)
            }
                .disabled(command.companion_page == 0 || companion_switcher.state == .disconnected)
        }
    }
}

//#Preview("FTC Switcher") {
//    MacroSetting("d1manualRunMacro", switcher: Switcher.get(division: 1), label: "Macro")
//}
