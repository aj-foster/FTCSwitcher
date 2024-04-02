import SwiftUI

struct DivisionView: View {
    @Binding var division: Division
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            DivisionSettingsView(division: $division)
                .padding([.bottom], 20)
            FieldView(division: $division)
                .padding([.bottom], 20)
            Text("Created by [FTAJ](https://youtube.com/@FTAAJ). If this application helped you, please consider making a [donation](https://donate.stripe.com/eVa8A63oQ0drcF2aEE) to the Orlando Robotics Foundation.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 320)
                .font(.system(size: 10))
        }
            .padding(20)
            .onDisappear {
                Scoring.remove(division.id)
                ATEM.remove(division.id)
                Companion.remove(division.id)
            }
            .onChange(of: division) { division in
                Scoring.get(division).update(division)
            }
    }
}

//#Preview("FTC Switcher") {
//    DivisionView(division: .constant(Division()))
//}
