import SwiftUI

struct DivisionSettingsView: View {
    @Binding var division: Division
    
    var body: some View {
        let _ = Self._printChanges()
        
        let scoring = Scoring.get(division)
        let switcher = Switcher.get(division)
        
        HStack(alignment: .top, spacing: 40) {
            Form {
                ScoringSettingsView(settings: $division.scoring_settings, scoring: scoring)
                Spacer().frame(height: 20)
                ATEMSettingsView(settings: $division.switcher_settings, switcher: switcher)
            }
            Form {
                FieldSettingsView(settings: $division.field_settings)
                Spacer().frame(height: 20)
                ManualRunView(division: $division.id, switcher: switcher)
            }
        }
    }
}

//#Preview("FTC Switcher") {
//    DivisionSettingsView(division: .constant(Division()), scoring: Scoring.get(division: 1), switcher: Switcher.get(division: 1))
//}
