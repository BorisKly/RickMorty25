//
//  NetworkMonitor.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import Foundation
import Alamofire

class NetworkMonitor: ObservableObject {
  
    @Published var isConnected: Bool = true
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        print(#function)
        reachabilityManager?.startListening { status in
            DispatchQueue.main.async {
                self.isConnected = (status == .reachable(.ethernetOrWiFi) || status == .reachable(.cellular))
                print("Network status: \(self.isConnected ? "Online" : "Offline")")
            }
        }
    }
    
    func checkConnection() {
            guard let status = reachabilityManager?.status else {
                print("Unable to check connection")
                return
            }
            
            DispatchQueue.main.async {
                self.isConnected = (status == .reachable(.ethernetOrWiFi) || status == .reachable(.cellular))
                print("Manual check: \(self.isConnected ? "Online" : "Offline")")
            }
        }
    
}
