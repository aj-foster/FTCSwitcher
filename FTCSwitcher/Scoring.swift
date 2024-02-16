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
//    private static var divisions: [Scoring] = []
//    static func division(_ division: Int) -> Scoring {
//        if divisions.count > division {
//            divisions[division]
//        } else {
//            for i in (divisions.count...division) {
//                divisions.append(Scoring(division: i))
//            }
//        }
//    }

    @Published var error: String?
    @Published var state: Scoring.State = .disconnected
    var division: Int
    var switcher: Switcher
    var socket: Starscream.WebSocket?
    var timer: Timer?
    
    init(division: Int, switcher: Switcher) {
        self.division = division
        self.switcher = switcher
    }
    
    func connect(hostname host: String, event_code code: String) {
        let url = "ws://\(host)/api/v2/stream/?code=\(code)"
        Log("Connecting to \(url)", tag: "Scoring")
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
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(_):
            Log("Connected", tag: "Scoring")
            error = nil
            state = .connected
            
        case .disconnected(let reason, _):
            error = reason
            Log("Disconnected", tag: "Scoring")
            error = nil
            state = .disconnected
            
        case .text(let string):
            guard string != "pong" else { break }
            Log("Received: \(string)", tag: "Scoring")

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
            Log("Change in websocket viability", tag: "Scoring")

        case .reconnectSuggested(_):
            Log("Reconnect suggested", tag: "Scoring")

        case .cancelled:
            Log("Connection cancelled", tag: "Scoring")
            state = .disconnected

        case .error(let error):
            Log("Websocket error: \(String(describing: error))", tag: "Scoring")
            self.error = error?.localizedDescription
            state = .disconnected

        case .binary(let data):
            Log("Received binary: \(data)", tag: "Scoring")
        case .ping(_): break
        case .pong(_): break
        case .peerClosed:
            Log("Connection closed by peer", tag: "Scoring")
            error = "Connection closed by scoring system"
            state = .disconnected
        }
    }
    
    func scoringEvent(_ event: String, _ field: Int) {
        Log("Event \(event)", tag: "Scoring")
        
        let translatedField = if field == 0 {
            UserDefaults.standard.integer(forKey: "d\(division)finalsField")
        } else {
            field
        }
        
        if let preference = ScoringEvents.first(where: { $0.id == event }) {
            let prefKey = "d\(division)f\(translatedField)WhateverMacro"
            let macro = UserDefaults.standard.integer(forKey: prefKey)
            
            switcher.sendMacro(macro)
        }
    }

    struct Event: Identifiable {
        var id: String
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
    Scoring.Event(id: "SHOW_PREVIEW", title: "Show Preview"),
    Scoring.Event(id: "SHOW_RANDOM", title: "Show Random"),
    Scoring.Event(id: "SHOW_MATCH", title: "Show Match"),
    Scoring.Event(id: "MATCH_START", title: "Start Match"),
    Scoring.Event(id: "AUTO_END", title: "End Autonomous"),
    Scoring.Event(id: "DRIVER_START", title: "Start Driver Control"),
    Scoring.Event(id: "ENDGAME", title: "Start Endgame"),
    Scoring.Event(id: "MATCH_END", title: "End Match"),
    Scoring.Event(id: "MATCH_POST", title: "Post Score")
]
