//
//  HomeInteractor.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.


import Foundation

protocol HomeInteractorProtocol {
    func getTags()
}

protocol HomeDataStore: class {
}

final class HomeInteractor: HomeInteractorProtocol, HomeDataStore {
    // MARK: - Properties
    private let presenter: HomePresenterProtocol?
    private let worker: HomeWorkerProtocol?
    
    private var tags: [HomeViewModel.Response.Result] = []
    
    private let itemsLimit = 30
    private let defaultTag = "sea"
    
    private var isNeedLoadNewData = true
    
    // MARK: - Init
    required init(worker: HomeWorkerProtocol, presenter: HomePresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    // MARK: - Requests
    func getTags() {
        guard isNeedLoadNewData else { return }
        let params = HomeViewModel.Parameters(tag: defaultTag, limit: itemsLimit, offset: tags.count)
        
        worker?.getTags(parameters: params, { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tags):
                let results = tags.results
                
                self.isNeedLoadNewData = results?.count != 0
                self.tags.append(contentsOf: results ?? [])
                self.presenter?.display(tags: self.tags)
                
            case .failure(let error):
                print(error)
            }
        })
    }
}
