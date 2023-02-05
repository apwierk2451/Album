//
//  AlbumInfo.swift
//  Album
//
//  Created by 이은찬 on 2023/02/04.
//

import Photos

struct AlbumInfo: Hashable {
    let name: String
    let count: Int
    let album: PHFetchResult<PHAsset>
}
