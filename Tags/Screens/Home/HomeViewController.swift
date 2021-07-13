//
//  HomeViewController.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HomeViewControllerProtocol: class {
    
}

final class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    static let builder = HomeBuilder()
    private var interactor: HomeInteractorProtocol!
    private var router: HomeRouterProtocol!
    
    private let collectionViewDataSource = HomeCollectionViewDataSouce()
    
    // MARK: - Setup
    func initialSetup(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - UI
    private func setupViews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionViewDataSource.cellAction = { [weak self] in
            guard let _ = self else { return }
            
        }
        
        collectionView.delegate = collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource
        
        collectionView.registerCell(TagCollectionViewCell.self)
    }
}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {
    
}
