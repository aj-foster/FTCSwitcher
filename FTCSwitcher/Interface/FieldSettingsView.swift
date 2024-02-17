import SwiftUI

struct FieldSettingsView: View {
    var division: Int
    
    @AppStorage private var field_count: Int
    @AppStorage private var finals_field: Int
    @AppStorage private var reverse_fields: Bool
    
    init(division: Int) {
        self.division = division

        _field_count = AppStorage(wrappedValue: 1, "d\(division)fieldCount")
        _finals_field = AppStorage(wrappedValue: 1, "d\(division)finalsField")
        _reverse_fields = AppStorage(wrappedValue: false, "d\(division)reverseFields")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        Section(header: Text("Setup").bold()) {
            HStack {
                TextField(value: $field_count, format: .number, prompt: Text("Number of playing fields")) {
                    Text("Field Count")
                }
                Stepper(value: $field_count, in: 1...4, step: 1) {}.labelsHidden()
                Help(text: "Must match the number of fields configured in the scoring software.", width: 240)
            }
            HStack {
                TextField(value: $finals_field, format: .number, prompt: Text("Field number")) {
                    Text("Finals Field")
                }
                Stepper(value: $finals_field, in: 1...field_count, step: 1) {}.labelsHidden()
                Help(text: "For events with elimination matches, which field will hold the finals. Usually field 1.", width: 200)
            }.padding([.bottom], 4)
            HStack {
                Picker("Orientation", selection: $reverse_fields) {
                    Text("Audience").tag(false)
                    Text("Scoring").tag(true)
                }.disabled(field_count <= 1)
                Help(text: "Changes the order of the fields in the interface below.", width: 200)
            }
        }
        .onChange(of: $field_count.wrappedValue) { new_field_count in
            finals_field = min(finals_field, new_field_count)
        }
    }
}

#Preview("FTC Switcher") {
    FieldSettingsView(division: 1)
}
