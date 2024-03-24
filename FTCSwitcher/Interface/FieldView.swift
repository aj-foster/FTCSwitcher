import SwiftUI

struct FieldView: View {
    private var division: Int
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    @AppStorage private var field_count: Int
    @AppStorage private var reverse_fields: Bool
    
    init(division: Int, scoring: Scoring, switcher: Switcher) {
        self.division = division
        self.scoring = scoring
        self.switcher = switcher
        
        _field_count = AppStorage(wrappedValue: 1, "d\(division)fieldCount")
        _reverse_fields = AppStorage(wrappedValue: false, "d\(division)reverseFields")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        let fields = if reverse_fields { Array((1...field_count).reversed()) } else { Array(1...field_count) }
        
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
                                MacroSetting("d\(division)field\(field)\(event.macro)Macro", switcher: switcher)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("FTC Switcher") {
    FieldView(division: 1, scoring: Scoring.get(division: 1), switcher: Switcher.get(division: 1))
}
