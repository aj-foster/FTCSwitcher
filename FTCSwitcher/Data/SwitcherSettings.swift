struct SwitcherSettings: Codable, Equatable {
    var host = ""
    var type: SwitcherType = .atem
    private var version = 1
}

enum SwitcherType: String, Codable {
    case atem = "ATEM"
    case companion = "Companion"
}
