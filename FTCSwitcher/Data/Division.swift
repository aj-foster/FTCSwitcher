import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var switcherConfigDocument: UTType {
        UTType(exportedAs: "com.aj-foster.FTCSwitcher.SwitcherConfig")
    }
}

struct Division: Codable, Equatable, FileDocument, Identifiable {
    //
    // Configuration
    //
    
    var id = UUID()
    
    var field_settings = FieldSettings()
    var scoring_settings = ScoringSettings()
    var switcher_settings = SwitcherSettings()
    var fields = [FieldCommands(), FieldCommands(), FieldCommands(), FieldCommands()]
    
    init() {}

    //
    // FileDocument Conformance
    //
    
    // For migration of files in the future
    private var version = 1

    static var readableContentTypes: [UTType] { [.switcherConfigDocument] }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            Log("Error: Failed to load file contents")
            throw DivisionDecodeError()
        }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys.union(.prettyPrinted)
        
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}

struct DivisionDecodeError: Error {}
