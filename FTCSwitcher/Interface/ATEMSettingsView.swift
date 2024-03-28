import SwiftUI

struct ATEMSettingsView: View {
    @Binding var settings: SwitcherSettings
    @ObservedObject var switcher: Switcher
    
    var body: some View {
        let _ = Self._printChanges()
        
        Section(header: Text("ATEM Switcher").bold()) {
            HStack {
                TextField(text: $settings.host, prompt: Text("Blank for USB")) {
                    Text("URL")
                }
                Help(text: "Leave blank if the ATEM switcher is connected via USB. Otherwise, input the IP address of the switcher.", width: 250)
            }.padding([.bottom], 5)
            HStack {
                Button(switcher.state == .connected ? "Disconnect" : "Connect") {
                    if switcher.state == .disconnected {
                        switcher.connect(settings.host)
                    } else {
                        switcher.disconnect()
                    }
                }
                Text(switcher.error ?? " ")
            }
        }
    }
}

//#Preview("FTC Switcher") {
//    ATEMSettingsView(settings: .constant(SwitcherSettings()), switcher: Switcher.get(division: 1))
//}
