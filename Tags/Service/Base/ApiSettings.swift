//
//  ApiSettings.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation

enum Environment {
    case dev
    case production
    
    var baseUrl: String {
        switch self {
        case .dev: return "https://www.deviantart.com/api/v1/oauth2"
        case .production: return "https://www.deviantart.com/api/v1/oauth2"
        }
    }
}

final class ApiSettings {
    init() {}

    private let currentEnviroment: Environment = .production
    private var currentDefaults: UserDefaults = .standard
        
    var serverBaseURL: String {
        return currentEnviroment.baseUrl
    }
    
    var token: String? {
        set {
            currentDefaults.set(newValue, forKey: Keys.token)
        }
        
        get {
            guard let value = currentDefaults.object(forKey: Keys.token) as? String else { return nil }
            return !value.isEmpty ? value : nil
        }
    }
}
