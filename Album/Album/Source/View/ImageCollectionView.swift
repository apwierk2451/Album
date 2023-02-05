//
//  ImageCollectionView.swift
//  Album
//
//  Created by 이은찬 on 2023/02/06.
//

import UIKit

final class ImageCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
