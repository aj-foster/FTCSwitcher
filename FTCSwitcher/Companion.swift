import Foundation
import os

class Companion: NSObject, ObservableObject {
    // MARK: Static interface
    
    static private var registry: [UUID : Companion] = [:]
    
    /**
     Get the Companion API instance associated with the given division
     
     If no Companion API instance exists for the division, a new one is created. Note that creating
     an instance does not automatically connect to the API, but it should be safely removed with
     the static `remove` function when a division closes.
     */
    static func get(_ division_id: UUID) -> Companion {
        if let switcher = registry[division_id] {
            return switcher
        } else {
            let switcher = Companion(division_id)
            registry[division_id] = switcher
            return switcher
        }
    }
    
    /**
     Disconnect the Companion API instance associated with the given division ID and remove it from
     the registry
     
     Any future attempts to `get` the API instance will result in a new instance.
     */
    static func remove(_ division_id: UUID) {
        if let switcher = registry[division_id] {
            switcher.disconnect()
            registry.removeValue(forKey: division_id)
        }
    }
    
    // MARK: Connection status
    
    @Published var error: String?
    @Published var state: Companion.State = .disconnected
    
    // MARK: Connection management

    private var division_id: UUID
    
    private init(_ division_id: UUID) {
        self.division_id = division_id
    }
    
    /**
     Connect to a Companion API on the network
     */
    func connect(_ host_and_port: String) {
        guard let url_with_scheme = URL(string: "http://\(host_and_port)") else {
            error = "Invalid host:port"
            return
        }
        
        url = url_with_scheme
        error = nil
        state = .connected
        Log("Connect to Companion \(host_and_port)", tag: "Companion \(division_id)")
        startURLSession()
        maintainConnection()
    }
    
    /**
     Disconnect from the Companion API
     */
    func disconnect() {
        error = nil
        Log("Disconnect", tag: "Companion \(division_id)")
        endURLSession()
        state = .disconnected
    }
    
    enum State {
        case disconnected
        case connected
    }
    
    // MARK: Macros
    
    /**
     Send a page/row/column button press to the Companion API
     
     The macro is ignored if is out-of-bounds (for example, non-positive page numbers) or if the
     API is marked as disconnected. Page, row, and column numbers given to this function should
     match the numbers shown on the Companion API surface.
     */
    func sendMacro(_ page: Int, _ row: Int, _ column: Int) {
        guard page >= 1, row >= 0, column >= 0 else { return }
        guard state == .connected else { Log("Intended to send macro \(page)/\(row)/\(column) but switcher is disconnected", tag: "Companion \(division_id)"); return }
        
        Log("Sending macro \(page)/\(row)/\(column)", tag: "Companion \(division_id)")
        
        guard let url = url?.withPath("/api/location/\(page)/\(row)/\(column)/press") else { return }
        if urlSession == nil { startURLSession() }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        if let task = urlSession?.dataTask(with: urlRequest) { task.resume() }
    }
    
    // MARK: HTTP Connections
    
    private var connectionTimer: Timer?
    private var connectionRetryCount = 0
    private var operationQueue = OperationQueue()
    private var urlSession: URLSession?
    private var url: URL?
    
    private func maintainConnection() {
        connectionTimer?.invalidate()
        connectionTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] timer in
            self?.checkConnection()
        }
        self.checkConnection()
    }
    
    private func checkConnection() {
        if urlSession == nil { startURLSession() }
        guard let url = url?.withPath("/") else { return }
        
        let urlRequest = URLRequest(url: url)
        if let task = urlSession?.dataTask(with: urlRequest) { task.resume() }
    }
    
    private func startURLSession() {
        let config = URLSessionConfiguration.ephemeral
        config.allowsConstrainedNetworkAccess = true
        config.allowsExpensiveNetworkAccess = true
        
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
    }
    
    private func endURLSession() {
        connectionTimer?.invalidate()
        urlSession?.invalidateAndCancel()
        urlSession = nil
    }
}

extension Companion: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: (any Error)?) {
        DispatchQueue.main.async {
            self.connectionRetryCount += 1
            self.error = error?.localizedDescription
        }
    }
}

extension Companion: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        if let response = response as? HTTPURLResponse {
            if response.statusCode >= 400 {
                DispatchQueue.main.async {
                    self.connectionRetryCount += 1
                    self.error = "Received \(response.statusCode) error (\(self.connectionRetryCount))"
                }
            } else if response.value(forHTTPHeaderField: "X-App") != "Bitfocus Companion" {
                DispatchQueue.main.async {
                    self.connectionRetryCount += 1
                    self.error = "Received response from non-Companion server (\(self.connectionRetryCount))"
                }
            } else {
                DispatchQueue.main.async {
                    self.connectionRetryCount = 0
                    self.error = nil
                }
            }
        }
        completionHandler(.allow)
    }
}

extension URL {
    func withPath(_ path: String) -> URL {
        var clone = self
        clone.append(path: path)
        return clone
    }
}
