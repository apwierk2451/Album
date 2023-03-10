//
//  AlbumTableViewCell.swift
//  Album
//
//  Created by 이은찬 on 2023/02/04.
//

import UIKit

final class AlbumTableViewCell: UITableViewCell {
    
    private enum AlbumTableViewCellNameSpace {
        static let albumTableViewCellIdentifier = "AlbumsCell"
        static let defaultImageName = "photo.on.rectangle"
        static let defaultAlbumTitle = ""
        static let defaultImageCount = "0"
    }
    
    static let identifier = AlbumTableViewCellNameSpace.albumTableViewCellIdentifier
    
    private let albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(
            systemName: AlbumTableViewCellNameSpace.defaultImageName
        )
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    private let albumTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
        
        return label
    }()
    
    private let albumCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 1))
        
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUIComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
    }
    
    private func addUIComponents() {
        contentView.addSubview(albumImage)
        contentView.addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(albumTitle)
        labelStackView.addArrangedSubview(albumCount)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            albumImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            albumImage.widthAnchor.constraint(equalToConstant: 70),
            albumImage.heightAnchor.constraint(equalTo: albumImage.widthAnchor),
            albumImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -5)
        ])
    }
    
    func configureImage(_ image: UIImage) {
        albumImage.image = image
    }
    
    func configureAlbumTitle(_ title: String) {
        albumTitle.text = title
    }
    
    func configureAlbumCount(_ count: Int) {
        albumCount.text = "\(count)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = nil
        albumTitle.text = AlbumTableViewCellNameSpace.defaultAlbumTitle
        albumCount.text = AlbumTableViewCellNameSpace.defaultImageCount
    }
}
