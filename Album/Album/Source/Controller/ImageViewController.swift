//
//  ImageViewController.swift
//  Album
//
//  Created by 이은찬 on 2023/02/06.
//

import UIKit
import Photos

class ImageViewController: UIViewController {
    
    private var albumTitle = ""
    private var images: [PHAsset] = []
    
    private lazy var imageCollectionView = ImageCollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
    
    private typealias ImageDataSource = UICollectionViewDiffableDataSource<Section, PHAsset>
    private typealias ImageSnapshot = NSDiffableDataSourceSnapshot<Section, PHAsset>
    
    private let imageManager = PHImageManager()
    
    private enum Section {
        case image
    }
    
    private var dataSource: ImageDataSource?
    
    init(title: String, images: [PHAsset]) {
        super.init(nibName: nil, bundle: nil)
        self.albumTitle = title
        self.images = images
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        addUIComponents()
        setupLayout()
        configureDataSource()
        appendDataSource()
    }
    
    private func setupDefault() {
        view.backgroundColor = .systemBackground
        navigationItem.title = albumTitle
    }
    
    private func addUIComponents() {
        view.addSubview(imageCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageCollectionView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let fraction: CGFloat = 1 / 3
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        let cell = UICollectionView.CellRegistration<ImageCollectionViewCell, PHAsset> { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            
            self.imageManager.requestImage(
                for: itemIdentifier,
                targetSize: .zero,
                contentMode: .aspectFill,
                options: .none
            ) { (image, _) in
                guard let image = image else { return }
                
                cell.configureImage(image: image)
            }
        }
        
        dataSource = ImageDataSource(
            collectionView: imageCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cell,
                    for: indexPath,
                    item: itemIdentifier
                )
            })
    }
    
    private func appendDataSource() {
        var snapshot = ImageSnapshot()
        snapshot.appendSections([.image])
        snapshot.appendItems(images)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}
