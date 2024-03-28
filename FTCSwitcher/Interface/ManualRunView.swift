import SwiftUI

struct ManualRunView: View {
    var division: UUID
    @State private var command = Command()
    @ObservedObject var switcher: Switcher

    var body: some View {
        let _ = Self._printChanges()
        
        Section(header: Text("Manual Run").bold()) {
            MacroSetting(command: $command, switcher: switcher, label: "Macro")
        }
    }
}

//#Preview("FTC Switcher") {
//    ManualRunView(division: 1, switcher: Switcher.get(division: 1))
//}
