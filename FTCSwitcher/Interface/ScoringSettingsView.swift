import SwiftUI

struct ScoringSettingsView: View {
    @Binding var settings: ScoringSettings
    @ObservedObject var scoring: Scoring

    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
 
        Section(header: Text("Scoring System").bold()) {
            HStack {
                TextField(text: $settings.host, prompt: Text("Hostname (ex. localhost)")) {
                    Text("Host")
                }
                Help(text: "Use \"localhost\" if the scoring system runs on the same computer, or the IP address displayed at the top of the scoring system otherwise.", width: 290)
            }
            HStack {
                TextField(text: $settings.code, prompt: Text("Event Code (ex. florlm1)")) {
                    Text("Event")
                }
                Help(text: "Event code (ex. \"usflorls\"), which usually appears in the URL of the event page.", width: 280)
            }.padding([.bottom], 5)
            HStack {
                Button(scoring.state == .connected ? "Disconnect" : "Connect") {
                    if scoring.state == .disconnected {
                        scoring.connect(hostname: settings.host, event_code: settings.code)
                    } else {
                        scoring.disconnect()
                    }
                }
                Text(scoring.error ?? " ")
            }
        }
    }
}

//#Preview("FTC Switcher") {
//    ScoringSettingsView(division: 1, scoring: Scoring.get(division: 1))
//}
