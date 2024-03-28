import Foundation

struct FieldCommands: Codable, Equatable, Identifiable {
    var id = UUID()
    var show_preview = Command()
    var show_random = Command()
    var show_match = Command()
    var match_start = Command()
    var auto_end = Command()
    var driver_start = Command()
    var endgame = Command()
    var match_end = Command()
    var match_post = Command()
    
    // For migration of files in the future
    private var version = 1
}

struct Command: Codable, Equatable {
    var atem_macro: Int = 0
    var companion_page: Int = 0
    var companion_row: Int = 0
    var companion_col: Int = 0
    
    // For migration of files in the future
    private var version = 1
}
