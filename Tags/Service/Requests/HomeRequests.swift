//
//  HomeRequests.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation

final class HomeRequests: RestClient {
    
    func getTags(parameters: HomeViewModel.Parameters, resp: @escaping ((Result<HomeViewModel.Response.Tags, CustomError>) -> Void)) {
        let url: String = baseUrl + Requests.Home.tags.rawValue
        
        http.queryBy(url, method: .get, parameters: nil, queue: .defaultQos) { response in
            self.response(result: response, modelCls: HomeViewModel.Response.Tags.self, resp: resp)
        }
    }
}
