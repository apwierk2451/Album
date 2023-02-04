//
//  AlbumViewController.swift
//  Album
//
//  Created by 이은찬 on 2023/02/03.
//

import UIKit
import Photos

final class AlbumViewController: UIViewController {
    private let albumsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 85
        tableView.register(AlbumTableViewCell.self,
                           forCellReuseIdentifier: AlbumTableViewCell.identifier)
        
        return tableView
    }()
    
    private let albumManager = AlbumManager.shared
    
    private enum Section {
        case main
    }
    
    private typealias AlbumDataSource = UITableViewDiffableDataSource<Section, AlbumInfo>
    private typealias AlbumSnapshot = NSDiffableDataSourceSnapshot<Section, AlbumInfo>
    
    private var dataSource: AlbumDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        addUIComponents()
        setupLayout()
        albumManager.checkPermission()
        configureDataSource()
        appendDataSource()
    }
    
    private func setupDefault() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "앨범"
        albumsTableView.delegate = self
    }
    
    private func addUIComponents() {
        view.addSubview(albumsTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            albumsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            albumsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            cell.configureAlbumCount(itemIdentifier.count)
            
            guard let asset = itemIdentifier.album.firstObject else {
                return UITableViewCell()
            }
            
            self?.albumManager.imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 70, height: 70),
                contentMode: .aspectFill,
                options: nil
            ) { (image, _) in
                guard let image = image else { return }
                
                cell.configureImage(album: image)
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
    
}
