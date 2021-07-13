//
//  HomePresenter.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol HomePresenterProtocol {
    init(view: HomeViewControllerProtocol)
}

final class HomePresenter: HomePresenterProtocol {
    private unowned let view: HomeViewControllerProtocol
    
    required init(view: HomeViewControllerProtocol) {
        self.view = view
    }
}
