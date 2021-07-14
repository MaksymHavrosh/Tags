//
//  ApiStructs.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation

struct Keys {
    static let token = "Authorization"
    static let kLostInternetConnection = "lostInternetConnection"}

struct Requests {
    
    enum Home: String {
        case tags = "/browse/tags"
    }
}
