//
//  GenreServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class GenreServiceTests: XCTestCase {
    
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
    
    /// Verifies successful genres list fetch — response contains at least one genre
    func test_getGenres_successfully() async {
        stubResponse(file: "genres_response", url: GenreEndpoint.list.url)
        do {
            let genres = try await sut.getGenres()
            XCTAssertFalse(genres.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error throws invalidResponse
    func test_getGenres_serverError() async {
        stubResponse(file: "genres_response", url: GenreEndpoint.list.url, statusCode: 500)
        do {
            _ = try await sut.getGenres()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies that invalid JSON throws invalidData
    func test_getGenres_invalidJSON() async {
        MockURLProtocol.stubResponseData = Data("invalid json".utf8)
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: GenreEndpoint.list.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        do {
            _ = try await sut.getGenres()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidData)
        }
    }
    
    /// Verifies genre fetch by slug — response slug matches requested slug
    func test_getGenreBySlug_successfully() async {
        let slug = "pop"
        stubResponse(file: "genre_by_slug_response", url: GenreEndpoint.bySlug(slug).url)
        do {
            let genre = try await sut.getGenreBySlug(slug: slug)
            XCTAssertEqual(genre.slug, slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on genre by slug throws invalidResponse
    func test_getGenreBySlug_serverError() async {
        let slug = "pop"
        stubResponse(file: "genre_by_slug_response", url: GenreEndpoint.bySlug(slug).url, statusCode: 404)
        do {
            _ = try await sut.getGenreBySlug(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies that network error propagates correctly
    func test_getGenres_networkError() async {
        MockURLProtocol.stubError = URLError(.notConnectedToInternet)
        do {
            _ = try await sut.getGenres()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
