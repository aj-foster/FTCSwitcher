import SwiftUI

struct ManualRunView: View {
    var division: Int
    @ObservedObject var switcher: Switcher
    
    @AppStorage private var switcher_url: String
    
    init(division: Int, switcher: Switcher) {
        self.division = division
        self.switcher = switcher
        
        _switcher_url = AppStorage(wrappedValue: "", "d\(division)switcherUrl")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        Section(header: Text("Manual Run").bold()) {
            MacroSetting("d\(division)manualRunMacro", switcher: switcher, label: "Macro")
        }
    }
}

#Preview("FTC Switcher") {
    ManualRunView(division: 1, switcher: Switcher.get(division: 1))
}
