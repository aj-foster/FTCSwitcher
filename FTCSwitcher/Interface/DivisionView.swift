import SwiftUI

struct DivisionView: View {
    private var division: Int
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    @AppStorage private var field_count: Int
    @AppStorage private var reverse_fields: Bool
    
    @State private var showScoringHostHelp = false
    @State private var showScoringCodeHelp = false
    @State private var showSwitcherURLHelp = false
    
    init(division: Int) {
        scoring = Scoring()
        switcher = Switcher()
        self.division = division
        
        _field_count = AppStorage(wrappedValue: 1, "d\(division)fieldCount")
        _reverse_fields = AppStorage(wrappedValue: false, "d\(division)reverseFields")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            DivisionSettingsView(division: division, scoring: scoring, switcher: switcher)
                .padding([.bottom], 20)
        
            Form {
                Section() {
                    Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 10) {
                        GridRow {
                            HStack {
                                Text("Macros").bold()
                                Help(text: "Number of the pre-programmed macro to use during each event. Use 0 to take no action.")
                            }
                            if reverse_fields {
                                ForEach((1...field_count).reversed(), id: \.self) { index in
                                    Text("Field \(index)").bold()
                                }
                            } else {
                                ForEach((1...field_count), id: \.self) { index in
                                    Text("Field \(index)").bold()
                                }
                            }
                        }
                        .padding([.bottom], 10)
                        ForEach(ScoringEvents) { event in
                            GridRow {
                                Text(event.title)
                                if reverse_fields {
                                    ForEach((1...field_count).reversed(), id: \.self) { index in
                                        MacroSetting("field\(index)\(event.macro)Macro")
                                    }
                                } else {
                                    ForEach((1...field_count), id: \.self) { index in
                                        MacroSetting("field\(index)\(event.macro)Macro")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("FTC Switcher") {
    DivisionView(division: 1)
}
