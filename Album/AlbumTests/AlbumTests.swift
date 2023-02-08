//
//  AlbumTests.swift
//  AlbumTests
//
//  Created by 이은찬 on 2023/02/03.
//

import XCTest
@testable import Album

final class AlbumTests: XCTestCase {
    var sut: AlbumManager!
    override func setUpWithError() throws {
        sut = AlbumManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_recents앨범명이_잘나오는지_확인() {
        // given
        sut.requestImageCollection()
        // when
        let result = sut.getAlbums().first?.name
        // then
        XCTAssertEqual(result, "Recents")
    }
    
    func test_favorites앨범명이_잘나오는지_확인() {
        // given
        sut.requestImageCollection()
        // when
        let result = sut.getAlbums()[1].name
        // then
        XCTAssertEqual(result, "Favorites")
    }
    
    func test_recents앨범_사진갯수_잘나오는지_확인() {
        // given
        sut.requestImageCollection()
        // when
        let result = sut.getAlbums().first?.album.count
        // then
        XCTAssertEqual(result, 6)
    }
    
    func test_favorites앨범_사진갯수_잘나오는지_확인() {
        // given
        sut.requestImageCollection()
        // when
        let result = sut.getAlbums()[1].album.count
        // then
        XCTAssertEqual(result, 0)
    }
}
