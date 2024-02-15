import SwiftData
import SwiftUI

struct DivisionSetupView: View {
    @Environment(\.modelContext) private var context
    @State private var id: PersistentIdentifier?
    @Query(sort: \Division.last_used) private var availableDivisions: [Division]
    
    var body: some View {
        if let id {
            let division = context.model(for: id) as! Division
            DivisionView(division: division)
        } else {
            if availableDivisions.count > 0 {
                Picker("Existing Event or Division", selection: $id) {
                    ForEach(availableDivisions) { division in
                        Text(division.name).tag(division.id)
                    }
                }
            } else {
                Button("Create New") {
                    let division = Division()
                    id = division.id
                }
            }
        }
    }
}

#Preview("FTC Switcher") {
    DivisionSetupView()
}
