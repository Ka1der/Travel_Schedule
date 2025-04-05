//
//  NetworkMonitor.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.04.2025.
//

import Network
import SwiftUI
import Combine

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true

    let connectionRestoredPublisher = PassthroughSubject<Void, Never>()
    
    static let shared = NetworkMonitor()
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            
            DispatchQueue.main.async {
                let wasRestored = !self!.isConnected && connected
                self?.isConnected = connected
                if wasRestored {
                    self?.connectionRestoredPublisher.send()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    func checkConnection() {
        let tempMonitor = NWPathMonitor()
        let tempQueue = DispatchQueue(label: "TempConnectionChecker")
        
        tempMonitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            
            DispatchQueue.main.async {
                if connected {
                    self?.isConnected = true
                    self?.connectionRestoredPublisher.send()
                    print("Проверка соединения: ПОДКЛЮЧЕНО")
                } else {
                    self?.isConnected = false
                    print("Проверка соединения: НЕТ ПОДКЛЮЧЕНИЯ")
                }
            }
            tempMonitor.cancel()
        }
        
        tempMonitor.start(queue: tempQueue)
    }
}
