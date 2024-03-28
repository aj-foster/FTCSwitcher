import Foundation
import Starscream

/**
 * Interface for the FTCLive Scoring software
 */
class Scoring: ObservableObject, WebSocketDelegate {
    // MARK: Static interface

    static private var registry: [UUID : Scoring] = [:]
    
    /**
     Get the scoring instance associated with the given division
     
     If no scoring instance exists for the division, a new one is created.
     */
    static func get(_ division: Division) -> Scoring {
        if let scoring = registry[division.id] {
            return scoring
        } else {
            let scoring = Scoring(division: division)
            registry[division.id] = scoring
            return scoring
        }
    }
    
    /**
     Disconnect the scoring instance associated with the given division ID and remove it from the
     registry
     
     Any future attempts to `get` the scoring instance will result in a new instance.
     */
    static func remove(_ division: UUID) {
        if let scoring = registry[division] {
            scoring.disconnect()
            registry.removeValue(forKey: division)
        }
    }
    
    // MARK: Connection status
    
    @Published var error: String?
    @Published var state: Scoring.State = .disconnected
    
    // MARK: Connection management
    
    private var division: Division
    private var socket: Starscream.WebSocket?
    private var timer: Timer?
    
    private init(division: Division) {
        self.division = division
    }
    
    /**
     Update information about the associated division
     
     This is especially important when, for example, the video switcher type (ATEM, Companion)
     changes.
     */
    func update(_ division: Division) {
        self.division = division
    }
    
    func connect(hostname host: String, event_code code: String) {
        let url = "ws://\(host)/api/v2/stream/?code=\(code)"
        Log("Connecting to \(url)", tag: "Scoring \(division)")
        error = nil
        
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        Log("Disconnect", tag: "Scoring")
        error = nil
        socket?.disconnect()
    }
    
    /*
     Callback for Starscream.WebSocketDelegate when messages are received
     
     This delegate receives information about a large number of events, but we only care about
     those representing certain actions in the _FIRST_ Tech Challenge scoring system. We also use
     this information to set the connection status and error information.
     */
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(_):
            Log("Connected", tag: "Scoring \(division)")
            error = nil
            state = .connected
            
        case .disconnected(let reason, _):
            error = reason
            Log("Disconnected", tag: "Scoring \(division)")
            error = nil
            state = .disconnected
            
        case .text(let string):
            guard string != "pong" else { break }
            Log("Received: \(string)", tag: "Scoring \(division)")

            let decoder = JSONDecoder()
            if let messageData = string.data(using: .utf8),
               let message = try? decoder.decode(Scoring.Message.self, from: messageData) {

                switch message.updateType {
                case "SHOW_PREVIEW", "SHOW_RANDOM", "SHOW_MATCH", "MATCH_POST":
                    scoringEvent(message.updateType, message.payload.field)
                    
                case "MATCH_START":
                    timer?.invalidate()
                    scoringEvent(message.updateType, message.payload.field)
                    
                    var secondsSinceStart = 0
                    let field = message.payload.field
                    
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                        secondsSinceStart += 1
                        
                        switch secondsSinceStart {
                        case 30:
                            self?.scoringEvent("AUTO_END", field)
                        case 38:
                            self?.scoringEvent("DRIVER_START", field)
                        case 128:
                            self?.scoringEvent("ENDGAME", field)
                        case 158:
                            self?.scoringEvent("MATCH_END", field)
                            timer.invalidate()
                        default:
                            break
                        }
                    }
                    
                    RunLoop.current.add(timer!, forMode: .common)

                case "MATCH_ABORT":
                    timer?.invalidate()
                    scoringEvent("MATCH_END", message.payload.field)
                    
                default:
                    break;
                }
            }

        case .viabilityChanged(_):
            Log("Change in websocket viability", tag: "Scoring \(division)")

        case .reconnectSuggested(_):
            Log("Reconnect suggested", tag: "Scoring \(division)")

        case .cancelled:
            Log("Connection cancelled", tag: "Scoring \(division)")
            state = .disconnected

        case .error(let error):
            Log("Websocket error: \(String(describing: error))", tag: "Scoring \(division)")
            self.error = error?.localizedDescription
            state = .disconnected

        case .binary(let data):
            Log("Received binary: \(data)", tag: "Scoring \(division)")
        case .ping(_): break
        case .pong(_): break
        case .peerClosed:
            Log("Connection closed by peer", tag: "Scoring \(division)")
            error = "Connection closed by scoring system"
            state = .disconnected
        }
    }
    
    private func scoringEvent(_ event: String, _ field: Int) {
        Log("Event \(event)", tag: "Scoring \(division)")
        
        let translatedField = if field == 0 {
            UserDefaults.standard.integer(forKey: "finalsField")
        } else {
            field
        }
        
        if let event = ScoringEvents.first(where: { $0.id == event }) {
            if division.switcher_settings.type == .atem {
                let macro = division.fields[translatedField - 1][keyPath: event.macro].atem_macro
                Switcher.get(division).sendMacro(macro)
            }
        }
    }

    struct Event: Identifiable {
        var id: String
        var macro: WritableKeyPath<FieldCommands, Command>
        var title: String
    }
    
    enum State {
        case disconnected
        case connected
    }
    
    struct Message: Decodable {
        let updateType: String
        let payload: Scoring.Message.Payload
        
        struct Payload: Decodable {
            let field: Int
        }
    }
}

var ScoringEvents = [
    Scoring.Event(id: "SHOW_PREVIEW", macro: \.show_preview, title: "Show Preview"),
    Scoring.Event(id: "SHOW_RANDOM", macro: \.show_random, title: "Show Random"),
    Scoring.Event(id: "SHOW_MATCH", macro: \.show_match, title: "Show Match"),
    Scoring.Event(id: "MATCH_START", macro: \.match_start, title: "Start Match"),
    Scoring.Event(id: "AUTO_END", macro: \.auto_end, title: "End Autonomous"),
    Scoring.Event(id: "DRIVER_START", macro: \.driver_start, title: "Start Driver Control"),
    Scoring.Event(id: "ENDGAME", macro: \.endgame, title: "Start Endgame"),
    Scoring.Event(id: "MATCH_END", macro: \.match_end, title: "End Match"),
    Scoring.Event(id: "MATCH_POST", macro: \.match_post, title: "Post Score")
]
