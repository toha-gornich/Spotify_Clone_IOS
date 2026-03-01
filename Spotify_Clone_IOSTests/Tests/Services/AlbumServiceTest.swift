//
//  AuthServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 25.02.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class AlbumServiceTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        sut = NetworkManager(session: session)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubHTTPResponse = nil
        MockURLProtocol.stubResponseData = nil
        super.tearDown()
    }
    
    func test_getAlbums_successfully() async {
        stubResponse(file: "albums_response", url: AlbumEndpoint.list.url)
        do {
            let response = try await sut.getAlbums()
            XCTAssertFalse(response.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func test_getAlbumBySlug_successfully() async {
        let slug = "warningspeed-up"
        stubResponse(file: "album_by_slug_response", url: AlbumEndpoint.bySlug(slug).url)
        do {
            let album = try await sut.getAlbumBySlug(slug: slug)
            XCTAssertEqual(album.slug, slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func test_getAlbumsBySlugArtist_successfully() async {
        let slug = "artist1"
        stubResponse(file: "albums_by_artist_response", url: AlbumEndpoint.byArtist(slug).url)
        do {
            let albums = try await sut.getAlbumsBySlugArtist(slug: slug)
            XCTAssertFalse(albums.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func test_getAlbumsFavorite_successfully() async {
        stubResponse(file: "albums_favorite_response", url: AlbumEndpoint.favorite.url)
        do {
            let albums = try await sut.getAlbumsFavorite()
            XCTAssertFalse(albums.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func test_postAddFavoriteAlbum_successfully() async {
        let slug = "after-hours"
        stubResponse(url: AlbumEndpoint.addFavorite(slug).url, statusCode: 201)
        do {
            try await sut.postAddFavoriteAlbum(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func test_deleteAlbumsFavorite_successfully() async {
        let slug = "after-hours"
        stubResponse(url: AlbumEndpoint.removeFavorite(slug).url, statusCode: 204)
        do {
            try await sut.deleteAlbumsFavorite(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
