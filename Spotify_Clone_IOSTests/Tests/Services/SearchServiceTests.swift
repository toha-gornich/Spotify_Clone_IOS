//
//  SearchServiceTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest

@testable import Spotify_Clone_IOS

final class SearchServiceTests: XCTestCase {
    
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
    
    /// Verifies successful tracks search — response contains at least one track
    func test_searchTracks_successfully() async {
        stubResponse(file: "search_tracks_response", url: SearchEndpoint.tracks("i-was-never-there", page: 1).url)
        do {
            let response = try await sut.searchTracks(searchText: "test")
            XCTAssertFalse(response.results.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on tracks search throws invalidResponse
    func test_searchTracks_serverError() async {
        stubResponse(url: SearchEndpoint.tracks("i-was-never-there", page: 1).url, statusCode: 500)
        do {
            _ = try await sut.searchTracks(searchText: "test")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful artists search — response contains at least one artist
    func test_searchArtists_successfully() async {
        stubResponse(file: "search_artists_response", url: SearchEndpoint.artists("artist", page: 1).url)
        do {
            let response = try await sut.searchArtists(searchText: "test")
            XCTAssertFalse(response.results.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful albums search — response contains at least one album
    func test_searchAlbums_successfully() async {
        stubResponse(file: "search_albums_response", url: SearchEndpoint.albums("album", page: 1).url)
        do {
            let response = try await sut.searchAlbums(searchText: "test")
            XCTAssertFalse(response.results.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful playlists search — response contains at least one playlist
    func test_searchPlaylists_successfully() async {
        stubResponse(file: "search_playlists_response", url: SearchEndpoint.playlists("playlist", page: 1).url)
        do {
            let response = try await sut.searchPlaylists(searchText: "test")
            XCTAssertFalse(response.results.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful profiles search — response contains at least one profile
    func test_searchProfiles_successfully() async {
        stubResponse(file: "search_profiles_response", url: SearchEndpoint.profiles("profile", page: 1).url)
        do {
            let response = try await sut.searchProfiles(searchText: "test")
            XCTAssertFalse(response.results.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that invalid JSON on tracks search throws invalidData
    func test_searchTracks_invalidJSON() async {
        MockURLProtocol.stubResponseData = Data("invalid json".utf8)
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: SearchEndpoint.tracks("test", page: 1).url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        do {
            _ = try await sut.searchTracks(searchText: "test")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidData)
        }
    }
}
