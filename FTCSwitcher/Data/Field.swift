import SwiftData

@Model
final class Field {
    var division: Division?
    var number: Int

    var macro_show_preview = 0
    var macro_show_random = 0
    var macro_show_match = 0
    var macro_match_start = 0
    var macro_auto_end = 0
    var macro_driver_start = 0
    var macro_endgame_start = 0
    var macro_match_end = 0
    var macro_match_post = 0
    
    init(division: Division, number: Int) {
        self.division = division
        self.number = number
    }
}
