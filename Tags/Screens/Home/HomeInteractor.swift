//
//  HomeInteractor.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.


import Foundation

protocol HomeInteractorProtocol {
    
}

protocol HomeDataStore: class {
}

class HomeInteractor: HomeInteractorProtocol, HomeDataStore {
    private let presenter: HomePresenterProtocol?
    private let worker: HomeWorkerProtocol?
    
    required init(worker: HomeWorkerProtocol, presenter: HomePresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}
