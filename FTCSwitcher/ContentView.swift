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
                    if Scoring.current.state == .disconnected {
                        Scoring.current.connect(hostname: scoring_host, event_code: scoring_code)
                    } else {
                        Scoring.current.disconnect()
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
                    if Switcher.current.state == .disconnected {
                        Switcher.current.connect(switcher_url)
                    } else {
                        
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
                    GridRow {
                        Text("Show Preview")
                        MacroSetting("field1ShowPreviewMacro")
                        MacroSetting("field2ShowPreviewMacro")
                    }
                    GridRow {
                        Text("Show Random")
                        MacroSetting("field1ShowRandomMacro")
                        MacroSetting("field2ShowRandomMacro")
                    }
                    GridRow {
                        Text("Show Match")
                        MacroSetting("field1ShowMatchMacro")
                        MacroSetting("field2ShowMatchMacro")
                    }
                    GridRow {
                        Text("Start Match")
                        MacroSetting("field1StartMatchMacro")
                        MacroSetting("field2StartMatchMacro")
                    }
                    GridRow {
                        Text("End Autonomous")
                        MacroSetting("field1EndAutoMacro")
                        MacroSetting("field2EndAutoMacro")
                    }
                    GridRow {
                        Text("Start Driver Control")
                        MacroSetting("field1StartDriverMacro")
                        MacroSetting("field2StartDriverMacro")
                    }
                    GridRow {
                        Text("Start Endgame")
                        MacroSetting("field1EndgameMacro")
                        MacroSetting("field2EndgameMacro")
                    }
                    GridRow {
                        Text("End Match")
                        MacroSetting("field1EndMatchMacro")
                        MacroSetting("field2EndMatchMacro")
                    }
                    GridRow {
                        Text("Post Score")
                        MacroSetting("field1PostScoreMacro")
                        MacroSetting("field2PostScoreMacro")
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
