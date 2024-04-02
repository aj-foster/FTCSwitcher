import SwiftUI

struct FieldSettingsView: View {
    @Binding var settings: FieldSettings

    var body: some View {
        #if DEBUG
            let _ = Self._printChanges()
        #endif
        
        Section(header: Text("Setup").bold()) {
            HStack {
                TextField(value: $settings.field_count, format: .number, prompt: Text("Number of playing fields")) {
                    Text("Field Count")
                }
                Stepper(value: $settings.field_count, in: 1...4, step: 1) {}.labelsHidden()
                Help(text: "Must match the number of fields configured in the scoring software.", width: 240)
            }
            HStack {
                TextField(value: $settings.finals_field, format: .number, prompt: Text("Field number")) {
                    Text("Finals Field")
                }
                Stepper(value: $settings.finals_field, in: 1...settings.field_count, step: 1) {}.labelsHidden()
                Help(text: "For events with elimination matches, which field will hold the finals. Usually field 1.", width: 200)
            }.padding([.bottom], 4)
            HStack {
                Picker("Orientation", selection: $settings.reverse_fields) {
                    Text("Normal").tag(false)
                    Text("Reverse").tag(true)
                }.disabled(settings.field_count <= 1)
                Help(text: "Changes the order of the fields in the interface below.", width: 200)
            }
        }
    }
}

#Preview("FTC Switcher") {
    FieldSettingsView(settings: .constant(FieldSettings()))
}
