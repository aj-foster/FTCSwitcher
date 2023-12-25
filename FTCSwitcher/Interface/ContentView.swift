//
//  ContentView.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/3/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    @AppStorage("scoringCode") private var scoring_code = ""
    @AppStorage("scoringHost") private var scoring_host = "localhost"
    @AppStorage("switcherUrl") private var switcher_url = ""
    
    @State private var showScoringHostHelp = false
    @State private var showScoringCodeHelp = false
    @State private var showSwitcherURLHelp = false
    
    var body: some View {
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
                }
                Button(scoring.state == .connected ? "Disconnect" : "Connect") {
                    if scoring.state == .disconnected {
                        scoring.connect(hostname: scoring_host, event_code: scoring_code)
                    } else {
                        scoring.disconnect()
                    }
                }
            }
            Spacer().frame(height: 40)
            Section(header: Text("ATEM Switcher").bold()) {
                HStack {
                    TextField(text: $switcher_url, prompt: Text("Blank for USB")) {
                        Text("URL")
                    }
                    Help(text: "Leave blank if the ATEM switcher is connected via USB. Otherwise, input the IP address of the switcher.", width: 250)
                }
                Button(switcher.state == .connected ? "Disconnect" : "Connect") {
                    if switcher.state == .disconnected {
                        switcher.connect(switcher_url)
                    } else {
                        switcher.disconnect()
                    }
                }
            }
            Spacer().frame(height: 40)
            Section() {
                Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 10) {
                    GridRow {
                        HStack {
                            Text("Macros").bold()
                            Help(text: "Number of the pre-programmed macro to use during each event.")
                        }
                        Text("Field 1").bold()
                        Text("Field 2").bold()
                    }
                    .padding([.bottom], 10)
                    ForEach(ScoringEvents) { event in
                        GridRow {
                            Text(event.title)
                            MacroSetting("field1\(event.macro)Macro")
                            MacroSetting("field2\(event.macro)Macro")
                        }
                    }
                }
            }
        }
        .padding([.top, .bottom], 40)
        .padding([.leading, .trailing], 20)
    }
}

#Preview("FTC Switcher") {
    ContentView(scoring: Scoring.current, switcher: Switcher.current)
}
