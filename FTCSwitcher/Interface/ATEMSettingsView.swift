import SwiftData
import SwiftUI

struct ATEMSettingsView: View {
    @Binding var division: Division
    @ObservedObject var switcher: Switcher
    
    var body: some View {
        let _ = Self._printChanges()
        Section(header: Text("ATEM Switcher").bold()) {
            HStack {
                TextField(text: $division.switcher, prompt: Text("Blank for USB")) {
                    Text("Host")
                }
                Help(text: "Leave blank if the ATEM switcher is connected via USB. Otherwise, input the IP address of the switcher.", width: 250)
            }.padding([.bottom], 5)
            HStack {
                Button(switcher.state == .connected ? "Disconnect" : "Connect") {
                    if switcher.state == .disconnected {
                        switcher.connect(division.switcher)
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
    let container = try! ModelContainer(for: Division.self)
    let context = ModelContext(container)
    var query = FetchDescriptor<Division>(sortBy: [SortDescriptor(\Division.last_used)])
    query.fetchLimit = 1
    let divisions = try! context.fetch(query)
    
    if let division = divisions.first {
        return ATEMSettingsView(division: .constant(division), switcher: Switcher())    } else {
        let division = Division.create()
            return ATEMSettingsView(division: .constant(division), switcher: Switcher())
    }
}
