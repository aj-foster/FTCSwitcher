struct ScoringSettings: Codable, Equatable {
    var code = ""
    var host = ""
    
    // For migration of files in the future
    private var version = 1
}
