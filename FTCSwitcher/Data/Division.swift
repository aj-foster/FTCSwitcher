import Foundation
import SwiftData

@Model
final class Division {
    var name: String
    var host: String
    var code: String
    var reverse: Bool
    var switcher: String
    var last_used: Date
    var field_count: Int
    var finals_field: Int
    
    var field1_macros: [String : Int]
    var field2_macros: [String : Int]
    
    init() {
        name = "Unnamed Event"
        host = ""
        code = ""
        reverse = false
        switcher = ""
        last_used = Date()
        field_count = 1
        finals_field = 1
        
        field1_macros = [:]
        field2_macros = [:]
    }
    
    static func create() -> Division {
        let container = try! ModelContainer(for: Division.self)
        let context = ModelContext(container)
        let division = Division()
        context.insert(division)
        
        return division
    }
}
