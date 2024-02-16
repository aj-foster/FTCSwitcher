import SwiftData
import SwiftUI

struct DivisionView: View {
    @State var division: Division
    
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    init(division: Division) {
        let switcher = Switcher()
        self.switcher = switcher
        self.division = division
        scoring = Scoring(division: 1, switcher: switcher)
    }
    
    var body: some View {
        let _ = Self._printChanges()

        VStack {
            Text(division.name)
            DivisionSettingsView(division: $division, scoring: scoring, switcher: switcher)
                .padding(40)
            Form {
                Section() {
                    Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 10) {
                        GridRow {
                            HStack {
                                Text("Macros").bold()
                                Help(text: "Number of the pre-programmed macro to use during each event. Use 0 to take no action.")
                            }
                            if division.reverse {
                                ForEach((1...division.field_count).reversed(), id: \.self) { index in
                                    Text("Field \(index)").bold()
                                }
                            } else {
                                ForEach((1...division.field_count), id: \.self) { index in
                                    Text("Field \(index)").bold()
                                }
                            }
                        }
                        .padding([.bottom], 10)
                        ForEach(ScoringEvents) { event in
                            GridRow {
                                Text(event.title)
                                if division.reverse {
                                    ForEach((1...division.field_count).reversed(), id: \.self) { field in
                                        MacroSetting(setting: macro_binding(field: field, macro: event.id), switcher: switcher)
                                    }
                                } else {
                                    ForEach((1...division.field_count), id: \.self) { field in
                                        MacroSetting(setting: macro_binding(field: field, macro: event.id), switcher: switcher)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding([.bottom], 20)
            .padding([.leading, .trailing], 40)
        }
    }
    
    private func macro_binding(field: Int, macro: String) -> Binding<Int> {
        if field == 1 {
            return Binding(get: {
                division.field1_macros[macro] ?? 0
            }, set: {
                division.field1_macros[macro] = $0
            })
        } else {
            return Binding(get: {
                division.field2_macros[macro] ?? 0
            }, set: {
                division.field2_macros[macro] = $0
            })
        }
    }
}

#Preview("FTC Switcher") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Division.self, configurations: config)
    let context = container.mainContext
    
    var query = FetchDescriptor<Division>(sortBy: [SortDescriptor(\Division.last_used)])
    query.fetchLimit = 1
    let divisions = try! context.fetch(query)
    
    if let division = divisions.first {
        return DivisionView(division: division)
    } else {
        let division = Division.create()
        return DivisionView(division: division)
    }
}
