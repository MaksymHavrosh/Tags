//
//  HomeWorker.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation

protocol HomeWorkerProtocol: class {
    func getTags(parameters: HomeViewModel.Parameters, _ completion: @escaping (Result<HomeViewModel.Response.Tags, CustomError>) -> Void)
}

final class HomeWorker: HomeWorkerProtocol {
    // MARK: - Properties
    private let homeAPI = HomeRequests()
    
    func getTags(parameters: HomeViewModel.Parameters,_ completion: @escaping (Result<HomeViewModel.Response.Tags, CustomError>) -> Void) {
        homeAPI.getTags(parameters: parameters) { result in
            completion(result)
        }
    }
}
