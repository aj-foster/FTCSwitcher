struct FieldSettings: Codable, Equatable {
    var field_count = 1 {
        didSet {
            if finals_field > field_count {
                finals_field = field_count
            }
        }
    }
    
    var finals_field = 1
    var reverse_fields = false
    
    // For migration of files in the future
    private var version = 1
}
