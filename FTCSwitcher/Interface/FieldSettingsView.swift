import SwiftData
import SwiftUI

struct FieldSettingsView: View {
    @Binding var division: Division
    
    var body: some View {
        let _ = Self._printChanges()
        Section(header: Text("Setup").bold()) {
            HStack {
                TextField(value: $division.field_count, format: .number, prompt: Text("Number of playing fields")) {
                    Text("Field Count")
                }
                Stepper(value: $division.field_count, in: 1...4, step: 1) {}.labelsHidden()
                Help(text: "Must match the number of fields configured in the scoring software.", width: 240)
            }
            HStack {
                TextField(value: $division.finals_field, format: .number, prompt: Text("Field number")) {
                    Text("Finals Field")
                }
                Stepper(value: $division.finals_field, in: 1...(division.field_count), step: 1) {}.labelsHidden()
                Help(text: "For events with elimination matches, which field will hold the finals. Usually field 1.", width: 200)
            }.padding([.bottom], 4)
            HStack {
                Picker("Orientation", selection: $division.reverse) {
                    Text("Normal").tag(false)
                    Text("Reverse").tag(true)
                }.disabled(division.field_count <= 1)
                Help(text: "Changes the order of the fields in the interface below.", width: 200)
            }
        }
//        .onChange(of: $field_count.wrappedValue) { new_field_count in
//            field_count = min(new_field_count, 4)
//            finals_field = min(finals_field, new_field_count)
//        }
    }
}

#Preview("FTC Switcher") {
    let container = try! ModelContainer(for: Division.self)
    let context = ModelContext(container)
    var query = FetchDescriptor<Division>(sortBy: [SortDescriptor(\Division.last_used)])
    query.fetchLimit = 1
    let divisions = try! context.fetch(query)
    
    if let division = divisions.first {
        return FieldSettingsView(division: .constant(division))
    } else {
        let division = Division.create()
        return FieldSettingsView(division: .constant(division))
    }
}
