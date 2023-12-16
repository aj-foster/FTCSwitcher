//
//  Scoring.swift
//  FTCSwitcher
//
//  Created by AJ Foster on 12/14/23.
//

import Foundation
import Starscream
import os

class Scoring: ObservableObject, WebSocketDelegate {
    
    @Published var state: ScoringState = .disconnected
    var socket: Starscream.WebSocket?
    var timer: Timer?
    
    static let current = Scoring()
    
    func connect(hostname host: String, event_code code: String) {
        let url = "ws://\(host)/api/v2/stream/?code=\(code)"
        var request = URLRequest(url: URL(string: url)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            state = .connected
            os_log("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            state = .disconnected
            os_log("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            if string == "pong" {
                break;
            }
            os_log("Received text: \(string)")


            let decoder = JSONDecoder()
            if let messageData = string.data(using: .utf8),
               let message = try? decoder.decode(ScoringMessage.self, from: messageData) {

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

                case "MATCH_ABORT":
                    timer?.invalidate()
                    scoringEvent("MATCH_END", message.payload.field)
                    
                default:
                    break;
                }
            }

            
        case .binary(let data):
            os_log("Received data: \(data.count)")
        case .ping(_):
            os_log("PING")
            break
        case .pong(_):
            os_log("PING")
            break
        case .viabilityChanged(_):
            os_log("viability changed")
            break
        case .reconnectSuggested(_):
            os_log("reconnect suggested")
            break
        case .cancelled:
            state = .disconnected
            os_log("cancelled")
        case .error(_):
            state = .disconnected
            os_log("error!")
//            handleError(error)
        case .peerClosed:
               break
        }
    }
    
    func scoringEvent(_ event: String, _ field: Int) {
        let preference =
            switch event {
            case "SHOW_PREVIEW":
                "ShowPreview"
            case "SHOW_RANDOM":
                "ShowRandom"
            case "SHOW_MATCH":
                "ShowMatch"
            case "MATCH_START":
                "StartMatch"
            case "AUTO_END":
                "EndAuto"
            case "DRIVER_START":
                "StartDriver"
            case "ENDGAME":
                "Endgame"
            case "MATCH_END":
                "EndMatch"
            case "MATCH_POST":
                "PostScore"
            default:
                nil as String?
            }
        
        if let preference {
            let prefKey = "field\(field)\(preference)Macro"
            let macro = UserDefaults.standard.integer(forKey: prefKey)
            
            Switcher.current.sendMacro(macro)
        }
    }
}

enum ScoringState {
    case disconnected
    case connected
}

struct ScoringMessage: Decodable {
    let updateType: String
    let payload: ScoringMessagePayload
}

struct ScoringMessagePayload: Decodable {
    let field: Int
}
