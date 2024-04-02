import SwiftUI

struct DivisionSettingsView: View {
    @Binding var division: Division
    
    var body: some View {
        let _ = Self._printChanges()
        
        let scoring = Scoring.get(division)
        
        HStack(alignment: .top, spacing: 40) {
            Form {
                ScoringSettingsView(settings: $division.scoring_settings, scoring: scoring)
                Spacer().frame(height: 20)
                SwitcherSettingsView(division: $division)
            }
            Form {
                FieldSettingsView(settings: $division.field_settings)
                Spacer().frame(height: 20)
                ManualRunView(division: $division)
            }
        }
    }
}

#Preview("FTC Switcher") {
    DivisionSettingsView(division: .constant(Division()))
}
