//
//  AlbumViewController.swift
//  Album
//
//  Created by 이은찬 on 2023/02/03.
//

import UIKit
import Photos

final class AlbumViewController: SuperViewControllerSetting {
    
    private enum AlbumViewControllerNameSpace {
        static let defaultNavigationTitle = "앨범"
        static let permissionMessage = "사진 앱 접근 권한이 없습니다.\n[설정] - [개인 정보 보호] - [사진]에서 설정해주세요."
    }
    
    private let albumsTableView = AlbumListView()
    
    private let albumManager = AlbumManager.shared
    private let imageManager = PHCachingImageManager()
    
    private enum Section {
        case main
    }
    
    private typealias AlbumDataSource = UITableViewDiffableDataSource<Section, AlbumInfo>
    private typealias AlbumSnapshot = NSDiffableDataSourceSnapshot<Section, AlbumInfo>
    
    private var dataSource: AlbumDataSource?
    
    override func setupDefault() {
        super.setupDefault()
        view.backgroundColor = .systemBackground
        navigationItem.title = AlbumViewControllerNameSpace.defaultNavigationTitle
        albumsTableView.delegate = self
        checkPermission()
        configureDataSource()
        appendDataSource()
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        view.addSubview(albumsTableView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            albumsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            albumsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func checkPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            albumManager.requestImageCollection()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                switch $0 {
                case .authorized:
                    self.albumManager.requestImageCollection()
                default:
                    break
                }
            })
        case .denied:
            setupPermission()
        default:
            break
        }
    }
    
    private func setupPermission() {
        let message = AlbumViewControllerNameSpace.permissionMessage
        let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        let okAction = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func configureDataSource() {
        dataSource = AlbumDataSource(tableView: albumsTableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AlbumTableViewCell.identifier,
                for: indexPath
            ) as? AlbumTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureAlbumTitle(itemIdentifier.name)
            cell.configureAlbumCount(itemIdentifier.album.count)
            
            if let asset = itemIdentifier.album.firstObject {
                self?.imageManager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 70, height: 70),
                    contentMode: .aspectFill,
                    options: nil
                ) { (image, _) in
                    guard let image = image else { return }
                    
                    cell.configureImage(image)
                }
            }
            
            return cell
        }
    }
    
    private func appendDataSource() {
        var snapshot = AlbumSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(albumManager.getAlbums())
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedAlbumImages: [PHAsset] = []
        let selectedAlbum = albumManager.getAlbums()[indexPath.row]
        for imageNumber in 0..<albumManager.getAlbums()[indexPath.row].album.count {
            let image = selectedAlbum.album[imageNumber]
            selectedAlbumImages.append(image)
        }
        let selectedAlbumTitle = albumManager.getAlbums()[indexPath.row].name
        let imageView = ImageViewController(title: selectedAlbumTitle, images: selectedAlbumImages)
        navigationController?.pushViewController(imageView, animated: true)
        albumsTableView.deselectRow(at: indexPath, animated: true)
    }
}
