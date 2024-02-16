import SwiftUI

struct DivisionSettingsView: View {
    var division: Int
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    @AppStorage("scoringCode") private var scoring_code = ""
    @AppStorage("scoringHost") private var scoring_host = "localhost"
    @AppStorage("switcherUrl") private var switcher_url = ""
    
    @AppStorage("fieldCount") private var field_count = 1
    @AppStorage("finalsField") private var finals_field = 1
    @AppStorage("reverseFields") private var reverse_fields = true
    
    @State private var showScoringHostHelp = false
    @State private var showScoringCodeHelp = false
    @State private var showSwitcherURLHelp = false
    
    var body: some View {
        let _ = Self._printChanges()
        
        HStack(alignment: .top, spacing: 40) {
            Form {
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
                Spacer().frame(height: 20)
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
            Form {
                Section(header: Text("Setup").bold()) {
                    HStack {
                        TextField(value: $field_count, format: .number, prompt: Text("Number of playing fields")) {
                            Text("Field Count")
                        }
                        Stepper(value: $field_count, in: 1...4, step: 1) {}.labelsHidden()
                        Help(text: "Must match the number of fields configured in the scoring software.", width: 240)
                    }
                    HStack {
                        TextField(value: $finals_field, format: .number, prompt: Text("Field number")) {
                            Text("Finals Field")
                        }
                        Stepper(value: $finals_field, in: 1...field_count, step: 1) {}.labelsHidden()
                        Help(text: "For events with elimination matches, which field will hold the finals. Usually field 1.", width: 200)
                    }.padding([.bottom], 4)
                    HStack {
                        Picker("Orientation", selection: $reverse_fields) {
                            Text("Audience").tag(false)
                            Text("Scoring").tag(true)
                        }.disabled(field_count <= 1)
                        Help(text: "Changes the order of the fields in the interface below.", width: 200)
                    }
                }
            }
        }
        .onChange(of: $field_count.wrappedValue) { new_field_count in
            finals_field = min(finals_field, new_field_count)
        }
    }
}

#Preview("FTC Switcher") {
    DivisionSettingsView(division: 1, scoring: Scoring(), switcher: Switcher())
}
