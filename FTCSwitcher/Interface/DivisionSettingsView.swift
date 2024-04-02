import SwiftUI

struct DivisionSettingsView: View {
    @Binding var division: Division
    
    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
        
        HStack(alignment: .top, spacing: 40) {
            Form {
                ScoringSettingsView(settings: $division.scoring_settings)
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

struct DivisionSettingsView_Preview: PreviewProvider {
    struct Preview: View {
        @State var division = Division()
        
        var body: some View {
            Form {
                DivisionSettingsView(division: $division)
                    .environmentObject(ATEM.get(division.id))
                    .environmentObject(Companion.get(division.id))
                    .environmentObject(Scoring.get(division))
            }
        }
    }

    static var previews: some View {
            Preview()
                .padding(20)
                .previewDisplayName("Division Settings")
    }
}
