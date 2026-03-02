//
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class MyAlbumsServiceTests: XCTestCase {
    
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
    
    /// Verifies successful my albums list fetch — response contains at least one album
    func test_getAlbumsMy_successfully() async {
        stubResponse(file: "my_albums_response", url: MyAlbumEndpoint.list.url)
        do {
            let albums = try await sut.getAlbumsMy()
            XCTAssertFalse(albums.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on my albums fetch throws invalidResponse
    func test_getAlbumsMy_serverError() async {
        stubResponse(url: MyAlbumEndpoint.list.url, statusCode: 500)
        do {
            _ = try await sut.getAlbumsMy()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful album creation — response contains valid album data
    func test_postCreateAlbum_successfully() async {
        stubResponse(file: "my_album_response", url: MyAlbumEndpoint.create.url, statusCode: 201)
        do {
            let album = try await sut.postCreateAlbum(
                title: "Test Album",
                description: "Test Description",
                releaseDate: "2024-01-01",
                isPrivate: false,
                imageData: nil
            )
            XCTAssertFalse(album.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on album creation throws invalidResponse
    func test_postCreateAlbum_serverError() async {
        stubResponse(url: MyAlbumEndpoint.create.url, statusCode: 400)
        do {
            _ = try await sut.postCreateAlbum(
                title: "Test Album",
                description: "Test Description",
                releaseDate: "2024-01-01",
                isPrivate: false,
                imageData: nil
            )
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful album patch — response contains updated album data
    func test_patchAlbumBySlugMy_successfully() async {
        let slug = "test-album"
        stubResponse(file: "album_by_slug_response", url: MyAlbumEndpoint.update(slug).url)
        do {
            let album = try await sut.patchAlbumBySlugMy(slug: slug, title: "Updated Title")
            XCTAssertFalse(album.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful album deletion — server returns 204 without error
    func test_deleteAlbumsMy_successfully() async {
        let slug = "test-album"
        stubResponse(url: MyAlbumEndpoint.delete(slug).url, statusCode: 204)
        do {
            try await sut.deleteAlbumsMy(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that deleting non-existent album throws invalidResponse
    func test_deleteAlbumsMy_notFound() async {
        let slug = "non-existent"
        stubResponse(url: MyAlbumEndpoint.delete(slug).url, statusCode: 404)
        do {
            try await sut.deleteAlbumsMy(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
}
