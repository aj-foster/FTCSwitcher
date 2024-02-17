import SwiftUI

struct ATEMSettingsView: View {
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
        
        Section(header: Text("ATEM Switcher").bold()) {
            HStack {
                TextField(text: $switcher_url, prompt: Text("Blank for USB")) {
                    Text("URL")
                }
                Help(text: "Leave blank if the ATEM switcher is connected via USB. Otherwise, input the IP address of the switcher.", width: 250)
            }.padding([.bottom], 5)
            HStack {
                Button(switcher.state == .connected ? "Disconnect" : "Connect") {
                    if switcher.state == .disconnected {
                        switcher.connect(switcher_url)
                    } else {
                        switcher.disconnect()
                    }
                }
                Text(switcher.error ?? " ")
            }
        }
    }
}

#Preview("FTC Switcher") {
    ATEMSettingsView(division: 1, switcher: Switcher.get(division: 1))
}
