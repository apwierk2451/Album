//
//  ImageCollectionViewCell.swift
//  Album
//
//  Created by 이은찬 on 2023/02/06.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private enum ImageCollectionViewCellNameSpace {
        static let imageCollectionViewCellIdentifier = "ImagesCell"
    }
    
    static let identifier = ImageCollectionViewCellNameSpace.imageCollectionViewCellIdentifier
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addUIComponents() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureImage(image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
