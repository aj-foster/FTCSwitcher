import SwiftUI

struct FieldView: View {
    @Binding var division: Division
    
    var body: some View {
        let _ = Self._printChanges()
        
        let fields = if division.field_settings.reverse_fields { Array((1...division.field_settings.field_count).reversed()) } else { Array(1...division.field_settings.field_count) }
        
        Form {
            Section() {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 5) {
                    GridRow {
                        HStack {
                            Text("Macros").bold()
                            Help(text: "Number of the pre-programmed macro to use during each event. Use 0 to take no action.")
                        }
                        ForEach(fields, id: \.self) { index in
                            Text("Field \(index)").bold()
                        }
                    }
                    .padding([.bottom], 5)
                    ForEach(ScoringEvents) { event in
                        GridRow {
                            Text(event.title)
                            ForEach(fields, id: \.self) { field in
                                let command = Binding(
                                    get: { division.fields[field - 1][keyPath: event.macro] },
                                    set: { division.fields[field - 1][keyPath: event.macro] = $0 }
                                )
                                MacroSetting(command: command, division: $division)
                            }
                        }
                    }
                }
            }
        }
    }
}

//#Preview("FTC Switcher") {
//    FieldView(division: 1, scoring: Scoring.get(division: 1), switcher: Switcher.get(division: 1))
//}
