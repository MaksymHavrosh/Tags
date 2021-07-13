//
//  TagCollectionViewCell.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//

import UIKit

protocol TagCollectionViewCellProtocol {
    
}

final class TagCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet private var roundedView: UIView!
    
    // MARK: - Properties
    private let cornerRadius: CGFloat = 15
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    // MARK: - UI
    private func setupViews() {
        
    }
}

// MARK: - TagCollectionViewCellProtocol
extension TagCollectionViewCell: TagCollectionViewCellProtocol {
    
}
