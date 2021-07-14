//
//  InternetService.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation
import Alamofire

final class InternetService {
    static let shared = InternetService()
    
    private let net = NetworkReachabilityManager()
    var internetHandler: ((_ isReachable: Bool) -> Void)?
    private var lastStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    static let status: String = "reachableStatus"
    
    private init() {}
    
    func start() {
        startNetworkReachabilityObserver()
    }
    
    private func startNetworkReachabilityObserver() {
        net?.startListening(onUpdatePerforming: { status in
            guard self.lastStatus != status else { return }
            self.lastStatus = status
            
            switch status {
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                NotificationCenter.default.post(name: .reachable, object: nil, userInfo: [InternetService.status: true])
                self.internetHandler?(true)
            case .notReachable:
                NotificationCenter.default.post(name: .reachable, object: nil, userInfo: [InternetService.status: false])
                self.internetHandler?(false)
            case .unknown:
                print("It is unknown whether the network is reachable")
            }
        })
    }
    
    func checkInternetConnect() -> Bool {
        guard let connect = self.net?.isReachable else { return false }
        return connect
    }
}
