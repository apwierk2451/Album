//
//  AlbumTableViewCell.swift
//  Album
//
//  Created by 이은찬 on 2023/02/04.
//

import UIKit

final class AlbumTableViewCell: UITableViewCell {
    
    static let identifier = "AlbumsCell"
    
    private let albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        
        return imageView
    }()
    
    private let albumName: UILabel = {
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
        
        labelStackView.addArrangedSubview(albumName)
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
    
    func configureImage(album: UIImage) {
        albumImage.image = album
    }
    
    func configureAlbumTitle(_ title: String) {
        albumName.text = title
    }
    
    func configureAlbumCount(_ count: Int) {
        albumCount.text = "\(count)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = UIImage(systemName: "photo.on.rectangle")
        albumName.text = ""
        albumCount.text = "0"
    }
}
