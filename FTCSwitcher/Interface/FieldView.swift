import SwiftUI

struct FieldView: View {
    @Binding var division: Division
    
    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
        
        let fields = if division.field_settings.reverse_fields { Array((1...division.field_settings.field_count).reversed()) } else { Array(1...division.field_settings.field_count) }
        
        Form {
            Section() {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 5) {
                    GridRow {
                        HStack {
                            Text(division.switcher_settings.type == .atem ? "Macros" : "Page / Row / Col").bold()
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

struct FieldView_Preview: PreviewProvider {
    struct Preview: View {
        @State var division = Division()
        
        var body: some View {
            Form {
                FieldView(division: $division)
                    .environmentObject(ATEM.get(division.id))
                    .environmentObject(Companion.get(division.id))
                    .environmentObject(Scoring.get(division))
            }
        }
    }

    static var previews: some View {
            Preview()
                .padding(20)
                .previewDisplayName("Field")
    }
}
