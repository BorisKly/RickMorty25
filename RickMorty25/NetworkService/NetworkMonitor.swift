//
//  NetworkMonitor.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import Foundation
import Network

class NetworkMonitor {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    var isConnected: Bool = true
    
    static let shared = NetworkMonitor()
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitorQueue")
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
                print("Connected to the network")
            } else {
                self?.isConnected = false
                print("No network connection")
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
