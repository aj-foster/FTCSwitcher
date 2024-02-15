import SwiftData
import SwiftUI

struct ScoringSettingsView: View {
    @Binding var division: Division
    @ObservedObject var scoring: Scoring
    
    var body: some View {
        let _ = Self._printChanges()

        Section(header: Text("Scoring System").bold()) {
            HStack {
                TextField(text: $division.host, prompt: Text("Hostname (ex. localhost)")) {
                    Text("Host")
                }
                Help(text: "Use \"localhost\" if the scoring system runs on the same computer, or the IP address displayed at the top of the scoring system otherwise.", width: 290)
            }
            HStack {
                TextField(text: $division.code, prompt: Text("Event Code (ex. florlm1)")) {
                    Text("Event")
                }
                Help(text: "Event code (ex. \"usflorls\"), which usually appears in the URL of the event page.", width: 280)
            }.padding([.bottom], 5)
            HStack {
                Button(scoring.state == .connected ? "Disconnect" : "Connect") {
                    if scoring.state == .disconnected {
                        scoring.connect(hostname: division.host, event_code: division.code)
                    } else {
                        scoring.disconnect()
                    }
                }
                Text(scoring.error ?? " ")
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
        let switcher = Switcher()
        let scoring = Scoring(division: 1, switcher: switcher)
        return ScoringSettingsView(division: .constant(division), scoring: scoring)
    } else {
        let division = Division.create()
        let switcher = Switcher()
        let scoring = Scoring(division: 1, switcher: switcher)
        return ScoringSettingsView(division: .constant(division), scoring: scoring)
    }
}
