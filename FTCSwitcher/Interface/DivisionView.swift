import SwiftUI

struct DivisionView: View {
    private var division: Int
    @ObservedObject var scoring: Scoring
    @ObservedObject var switcher: Switcher
    
    @AppStorage private var field_count: Int
    @AppStorage private var reverse_fields: Bool
    
    init(division: Int) {
        scoring = Scoring.get(division: division)
        switcher = Switcher.get(division: division)
        self.division = division
        
        _field_count = AppStorage(wrappedValue: 1, "d\(division)fieldCount")
        _reverse_fields = AppStorage(wrappedValue: false, "d\(division)reverseFields")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            DivisionSettingsView(division: division, scoring: scoring, switcher: switcher)
                .padding([.bottom], 20)
            FieldView(division: division, scoring: scoring, switcher: switcher)
        }
    }
}

#Preview("FTC Switcher") {
    DivisionView(division: 1)
}
