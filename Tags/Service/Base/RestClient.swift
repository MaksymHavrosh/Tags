//
//  RestClient.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation
import Alamofire

class RestClient: NSObject {
    
    let http = HttpService()
    let baseUrl = ApiSettings().serverBaseURL
    
    func response<P: Codable>(result: Result<Data, CustomError>, modelCls: P.Type, resp: @escaping (Result<P, CustomError>) -> Void) {
        
        switch result {
        case .success(let data):
            
            guard let jResp = (try? JSONSerialization.jsonObject(with: data)) else {
                
                let serverError = CustomError.init(localizedDescription: "Server error", code: 0)
                return resp(.failure(serverError))
            }
        
            print("======== Request =========")
            print(jResp)
            
            do {
                let model = try JSONDecoder().decode(modelCls.self, from: data)
                
                return resp(.success(model))
            } catch let error {
                let parsingError = CustomError.init(localizedDescription: error.localizedDescription, code: 0)
                return resp(.failure(parsingError))
            }
 
        case .failure(let error):
            return resp(.failure(error))
        }
    }
    
    func cancellRequests() {
        http.cancellAllRequests()
    }
}
