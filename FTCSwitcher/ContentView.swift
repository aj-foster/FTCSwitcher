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
    
    @AppStorage("field1ShowPreviewMacro") private var field1ShowPreviewMacro = 0
    @AppStorage("field1ShowRandomMacro") private var field1ShowRandomMacro = 0
    @AppStorage("field1ShowMatchMacro") private var field1ShowMatchMacro = 0
    @AppStorage("field1StartMatchMacro") private var field1StartMatchMacro = 0
    @AppStorage("field1EndAutoMacro") private var field1EndAutoMacro = 0
    @AppStorage("field1StartDriverMacro") private var field1StartDriverMacro = 0
    @AppStorage("field1EndgameMacro") private var field1EndgameMacro = 0
    @AppStorage("field1EndMatchMacro") private var field1EndMatchMacro = 0
    @AppStorage("field1PostScoreMacro") private var field1PostScoreMacro = 0
    
    @AppStorage("field2ShowPreviewMacro") private var field2ShowPreviewMacro = 0
    @AppStorage("field2ShowRandomMacro") private var field2ShowRandomMacro = 0
    @AppStorage("field2ShowMatchMacro") private var field2ShowMatchMacro = 0
    @AppStorage("field2StartMatchMacro") private var field2StartMatchMacro = 0
    @AppStorage("field2EndAutoMacro") private var field2EndAutoMacro = 0
    @AppStorage("field2StartDriverMacro") private var field2StartDriverMacro = 0
    @AppStorage("field2EndgameMacro") private var field2EndgameMacro = 0
    @AppStorage("field2EndMatchMacro") private var field2EndMatchMacro = 0
    @AppStorage("field2PostScoreMacro") private var field2PostScoreMacro = 0
    
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("Scoring System").bold()) {
                        TextField(text: $scoring_host, prompt: Text("Hostname (ex. localhost)")) {
                            Text("Host")
                        }
                        TextField(text: $scoring_code, prompt: Text("Event Code (ex. florlm1)")) {
                            Text("Event")
                        }
                        Button(scoring.state == .connected ? "Disconnect" : "Connect") {
                            if Scoring.current.state == .disconnected {
                                Scoring.current.connect(hostname: scoring_host, event_code: scoring_code)
                            } else {
                                
                            }
                        }
                    }
                    Spacer().frame(height: 20)
                    Section(header: Text("ATEM Switcher").bold()) {
                        TextField(text: $switcher_url, prompt: Text("Blank for USB")) {
                            Text("URL")
                        }
                        Button(switcher.state == .connected ? "Disconnect" : "Connect") {
                            if Switcher.current.state == .disconnected {
                                Switcher.current.connect(switcher_url)
                            } else {
                                
                            }
                        }
                    }
                }
                Form {
                    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                        GridRow {
                            Spacer()
                            Text("Field 1").bold()
                            Text("Field 2").bold()
                        }
                        GridRow {
                            Text("Show Preview")
                            TextField("", value: $field1ShowPreviewMacro, format: .number).labelsHidden()
                            TextField("", value: $field2ShowPreviewMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Show Random")
                            TextField("", value: $field1ShowRandomMacro, format: .number).labelsHidden()
                            TextField("", value: $field2ShowRandomMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Show Match")
                            TextField("", value: $field1ShowMatchMacro, format: .number).labelsHidden()
                            TextField("", value: $field2ShowMatchMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Start Match")
                            TextField("", value: $field1StartMatchMacro, format: .number).labelsHidden()
                            TextField("", value: $field2StartMatchMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("End Autonomous")
                            TextField("", value: $field1EndAutoMacro, format: .number).labelsHidden()
                            TextField("", value: $field2EndAutoMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Start Driver Control")
                            TextField("", value: $field1StartDriverMacro, format: .number).labelsHidden()
                            TextField("", value: $field2StartDriverMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Start Endgame")
                            TextField("", value: $field1EndgameMacro, format: .number).labelsHidden()
                            TextField("", value: $field2EndgameMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("End Match")
                            TextField("", value: $field1EndMatchMacro, format: .number).labelsHidden()
                            TextField("", value: $field2EndMatchMacro, format: .number).labelsHidden()
                        }
                        GridRow {
                            Text("Post Score")
                            TextField("", value: $field1PostScoreMacro, format: .number).labelsHidden()
                            TextField("", value: $field2PostScoreMacro, format: .number).labelsHidden()
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView(scoring: Scoring.current, switcher: Switcher.current)
}
