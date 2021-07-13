//
//  HomeCollectionViewDataSouce.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//

import UIKit

final class HomeCollectionViewDataSouce: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cellAction: (() -> Void)?
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TagCollectionViewCell.self, for: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellAction?()
    }
}
