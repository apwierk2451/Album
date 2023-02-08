//
//  AlbumManager.swift
//  Album
//
//  Created by 이은찬 on 2023/02/03.
//

import Photos

final class AlbumManager {
    
    private enum AlbumManagerNameSpace {
        static let imageFetchOptionSortKey = "creationDate"
    }
    
    static let shared = AlbumManager()
    
    private var albums = [AlbumInfo]()
    
    private var fetchOptions: PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: AlbumManagerNameSpace.imageFetchOptionSortKey, ascending: false)]

        return fetchOptions
    }
    
    func requestImageCollection() {
        let recents = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        addAlbums(collection: recents)
        addAlbums(collection: favorites)
        addAlbums(collection: userCollections)
    }
    
    private func addAlbums(collection: PHFetchResult<PHAssetCollection>) {
        var name: [String] = []
        var fetchResults: [PHFetchResult<PHAsset>] = []
        
        collection.enumerateObjects { smartAlbum, _, _ in
            guard let albumName = smartAlbum.localizedTitle else { return }
            
            name.append(albumName)
        }
        
        for i in 0..<collection.count {
            let collection = collection.object(at: i)
            let asset = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            fetchResults.append(asset)
        }
        
        for collectionIndex in 0..<collection.count {
            let album = AlbumInfo(
                name: name[collectionIndex],
                album: fetchResults[collectionIndex]
            )
            albums.append(album)
        }
    }
    
    func getAlbums() -> [AlbumInfo] {
        return albums
    }
}
