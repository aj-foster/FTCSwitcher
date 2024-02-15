import SwiftData
import SwiftUI

struct DivisionSettingsView: View {
    @Binding var division: Division
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    var body: some View {
        let _ = Self._printChanges()
        HStack(alignment: .top, spacing: 40) {
            Form {
                ScoringSettingsView(division: $division, scoring: scoring)
                Spacer().frame(height: 40)
                ATEMSettingsView(division: $division, switcher: switcher)
            }
            Form {
                FieldSettingsView(division: $division)
            }
        }
    }
}

#Preview("FTC Switcher") {
    let container = try! ModelContainer(for: Division.self)
    let context = ModelContext(container)
    var query = FetchDescriptor<Division>(sortBy: [SortDescriptor(\Division.last_used)])
    query.fetchLimit = 1
    let divisions = try! context.fetch(query)
    
    if let division = divisions.first {
        let switcher = Switcher()
        let scoring = Scoring(division: 1, switcher: switcher)
        return DivisionSettingsView(division: .constant(division), scoring: scoring, switcher: switcher)
    } else {
        let division = Division.create()
        let switcher = Switcher()
        let scoring = Scoring(division: 1, switcher: switcher)
        return DivisionSettingsView(division: .constant(division), scoring: scoring, switcher: switcher)
    }
}
