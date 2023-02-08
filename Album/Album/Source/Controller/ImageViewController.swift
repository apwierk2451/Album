//
//  ImageViewController.swift
//  Album
//
//  Created by 이은찬 on 2023/02/06.
//

import UIKit
import Photos

final class ImageViewController: SuperViewControllerSetting {
    private var albumTitle = ""
    private var images: [PHAsset] = []
    
    private lazy var imageCollectionView = ImageCollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
    private lazy var emptyView = EmptyView()
    
    private typealias ImageDataSource = UICollectionViewDiffableDataSource<Section, PHAsset>
    private typealias ImageSnapshot = NSDiffableDataSourceSnapshot<Section, PHAsset>
    
    private let imageManager = PHImageManager()
    
    private enum Section {
        case image
    }
    
    private var dataSource: ImageDataSource?
    
    init(title: String, images: [PHAsset]) {
        super.init()
        self.albumTitle = title
        self.images = images
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupDefault() {
        super.setupDefault()
        view.backgroundColor = .systemBackground
        navigationItem.title = albumTitle
        
        if isAlbumEmpty() == false {
            imageCollectionView.delegate = self
            configureDataSource()
            appendDataSource()
        }
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        if isAlbumEmpty() {
            view.addSubview(emptyView)
        } else {
            view.addSubview(imageCollectionView)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        if isAlbumEmpty() {
            NSLayoutConstraint.activate([
                emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emptyView.topAnchor.constraint(equalTo: view.topAnchor),
                emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
                imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
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
        DispatchQueue.main.async {
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    private func getImageInfo(image: PHAsset) -> String {
        let resource = PHAssetResource.assetResources(for: image)
        guard let filename = resource.first?.originalFilename,
              let unsignedInt64 = resource.first?.value(forKey: "fileSize") as? CLong else { return "" }
        
        let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
        let fileSize = String(format: "%.2f", Double(sizeOnDisk) / (1024.0 * 1024.0))+" MB"
        
        let message = "파일명 : \(filename)\n파일크기 : \(fileSize)"
        
        return message
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "사진 정보", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func isAlbumEmpty() -> Bool {
        return images.count > 0 ? false : true
    }
    
    @objc
    private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension ImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = getImageInfo(image: images[indexPath.row])
        showAlert(message)
    }
}
