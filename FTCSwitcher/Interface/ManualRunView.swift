import SwiftUI

struct ManualRunView: View {
    @Binding var division: Division
    @State private var command = Command()

    var body: some View {
        let _ = Self._printChanges()
        
        Section(header: Text("Manual Run").bold()) {
            MacroSetting(command: $command, division: $division, label: "Macro")
        }
    }
}

//#Preview("FTC Switcher") {
//    ManualRunView(division: 1, switcher: Switcher.get(division: 1))
//}
