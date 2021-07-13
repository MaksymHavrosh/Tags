//
//  HomeRouter.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol HomeRouterProtocol: class {
    init(view: UIViewController, interactor: HomeDataStore)
}

final class HomeRouter: HomeRouterProtocol {
    private unowned let view: UIViewController
    private unowned let dataStore: HomeDataStore
    
    required init(view: UIViewController, interactor: HomeDataStore) {
        self.view = view
        self.dataStore = interactor
    }
}
