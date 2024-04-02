import SwiftUI

struct ManualRunView: View {
    @Binding var division: Division
    @State private var command = Command()

    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
        
        Section(header: Text("Manual Run").bold()) {
            MacroSetting(command: $command, division: $division, label: "Macro")
        }
    }
}

struct ManualRunView_Preview: PreviewProvider {
    struct Preview: View {
        @State var division = Division()
        
        var body: some View {
            Form {
                ManualRunView(division: $division)
                    .environmentObject(ATEM.get(division.id))
                    .environmentObject(Companion.get(division.id))
                    .environmentObject(Scoring.get(division))
            }
        }
    }

    static var previews: some View {
            Preview()
                .padding(20)
                .previewDisplayName("Manual Run")
    }
}
