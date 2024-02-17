import SwiftUI

struct ScoringSettingsView: View {
    var division: Int
    @ObservedObject var scoring: Scoring
    
    @AppStorage private var scoring_code: String
    @AppStorage private var scoring_host: String
    
    init(division: Int, scoring: Scoring) {
        self.division = division
        self.scoring = scoring
        
        _scoring_code = AppStorage(wrappedValue: "", "d\(division)scoringCode")
        _scoring_host = AppStorage(wrappedValue: "localhost", "d\(division)scoringHost")
    }
    
    var body: some View {
        let _ = Self._printChanges()
 
        Section(header: Text("Scoring System").bold()) {
            HStack {
                TextField(text: $scoring_host, prompt: Text("Hostname (ex. localhost)")) {
                    Text("Host")
                }
                Help(text: "Use \"localhost\" if the scoring system runs on the same computer, or the IP address displayed at the top of the scoring system otherwise.", width: 290)
            }
            HStack {
                TextField(text: $scoring_code, prompt: Text("Event Code (ex. florlm1)")) {
                    Text("Event")
                }
                Help(text: "Event code (ex. \"usflorls\"), which usually appears in the URL of the event page.", width: 280)
            }.padding([.bottom], 5)
            HStack {
                Button(scoring.state == .connected ? "Disconnect" : "Connect") {
                    if scoring.state == .disconnected {
                        scoring.connect(hostname: scoring_host, event_code: scoring_code)
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
    ScoringSettingsView(division: 1, scoring: Scoring.get(division: 1))
}
