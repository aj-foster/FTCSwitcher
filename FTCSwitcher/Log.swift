import Foundation

fileprivate var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SSSS"
    return dateFormatter
}()

func Log(_ message: String, tag: String = "", file: String = #file, function: String = #function, line: Int = #line) {
    let tagText = if tag != "" { "[\(tag)] " } else { "" }
    let timeText = dateFormatter.string(from: .init())
    print("\(tagText)\(timeText): \(message)")
}
