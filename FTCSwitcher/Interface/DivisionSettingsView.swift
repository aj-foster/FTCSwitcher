import SwiftUI

struct DivisionSettingsView: View {
    var division: Int
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    var body: some View {
        let _ = Self._printChanges()
        
        HStack(alignment: .top, spacing: 40) {
            Form {
                ScoringSettingsView(division: division, scoring: scoring)
                Spacer().frame(height: 20)
                ATEMSettingsView(division: division, switcher: switcher)
            }
            Form {
                FieldSettingsView(division: division)
                Spacer().frame(height: 20)
                ManualRunView(division: division, switcher: switcher)
            }
        }
    }
}

#Preview("FTC Switcher") {
    DivisionSettingsView(division: 1, scoring: Scoring.get(division: 1), switcher: Switcher.get(division: 1))
}
