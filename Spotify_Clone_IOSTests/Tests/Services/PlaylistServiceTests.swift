    //
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class PlaylistServiceTests: XCTestCase {
    
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
    
    /// Verifies successful playlists list fetch — response contains at least one playlist
    func test_getPlaylists_successfully() async {
        stubResponse(file: "playlists_response", url: PlaylistEndpoint.list.url)
        do {
            let playlists = try await sut.getPlaylists()
            XCTAssertFalse(playlists.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on playlists fetch throws invalidResponse
    func test_getPlaylists_serverError() async {
        stubResponse(url: PlaylistEndpoint.list.url, statusCode: 500)
        do {
            _ = try await sut.getPlaylists()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies playlist fetch by slug — response contains valid playlist data
    func test_getPlaylistsBySlug_successfully() async {
        let slug = "my-playlist-3-2"
        stubResponse(file: "playlist_detail_response", url: PlaylistEndpoint.bySlug(slug).url)
        do {
            let playlist = try await sut.getPlaylistsBySlug(slug: slug)
            XCTAssertFalse(playlist.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies playlists fetch by user id — response contains at least one playlist
    func test_getPlaylistsByIdUser_successfully() async {
        let userId = 1
        stubResponse(file: "playlists_response", url: PlaylistEndpoint.byUser(userId).url)
        do {
            let playlists = try await sut.getPlaylistsByIdUser(idUser: userId)
            XCTAssertFalse(playlists.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies playlists fetch by genre slug — response contains at least one playlist
    func test_getPlaylistsBySlugGenre_successfully() async {
        let slug = "pop"
        stubResponse(file: "playlists_response", url: PlaylistEndpoint.byGenre(slug).url)
        do {
            let playlists = try await sut.getPlaylistsBySlugGenre(slug: slug)
            XCTAssertFalse(playlists.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies favorite playlists fetch — response contains at least one playlist
    func test_getPlaylistsFavorite_successfully() async {
        stubResponse(file: "playlists_favorite_response", url: PlaylistEndpoint.favorite.url)
        do {
            let playlists = try await sut.getPlaylistsFavorite()
            XCTAssertFalse(playlists.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful playlist creation — response contains valid playlist data
    func test_postMyPlaylist_successfully() async {
        stubResponse(file: "playlist_detail_response", url: PlaylistEndpoint.create.url, statusCode: 201)
        do {
            let playlist = try await sut.postMyPlaylist()
            XCTAssertFalse(playlist.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful track addition to playlist — server returns 200 without error
    func test_postTrackToPlaylist_successfully() async {
        let slug = "test-playlist"
        let trackSlug = "test-track"
        stubResponse(url: PlaylistEndpoint.addTrack(slug, trackSlug).url, statusCode: 200)
        do {
            try await sut.postTrackToPlaylist(slug: slug, trackSlug: trackSlug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that adding track to playlist with server error throws invalidResponse
    func test_postTrackToPlaylist_serverError() async {
        let slug = "test-playlist"
        let trackSlug = "test-track"
        stubResponse(url: PlaylistEndpoint.addTrack(slug, trackSlug).url, statusCode: 500)
        do {
            try await sut.postTrackToPlaylist(slug: slug, trackSlug: trackSlug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful track deletion from playlist — server returns 204 without error
    func test_deleteTrackFromPlaylist_successfully() async {
        let slug = "test-playlist"
        let trackSlug = "test-track"
        stubResponse(url: PlaylistEndpoint.deleteTrack(slug, trackSlug).url, statusCode: 204)
        do {
            try await sut.deleteTrackFromPlaylist(slug: slug, trackSlug: trackSlug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful playlist deletion — server returns 204 without error
    func test_deletePlaylist_successfully() async {
        let slug = "test-playlist"
        stubResponse(url: PlaylistEndpoint.delete(slug).url, statusCode: 204)
        do {
            try await sut.deletePlaylist(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies adding playlist to favorites — server returns 200 without error
    func test_postAddFavoritePlaylist_successfully() async {
        let slug = "test-playlist"
        stubResponse(url: PlaylistEndpoint.addFavorite(slug).url, statusCode: 200)
        do {
            try await sut.postAddFavoritePlaylist(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that adding already favorited playlist throws alreadyLiked error
    func test_postAddFavoritePlaylist_alreadyLiked() async {
        let slug = "test-playlist"
        stubResponse(url: PlaylistEndpoint.addFavorite(slug).url, statusCode: 409)
        do {
            try await sut.postAddFavoritePlaylist(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? FavoriteError, .alreadyLiked)
        }
    }
    
    /// Verifies successful playlist patch — response contains updated playlist data
    func test_patchPlaylist_successfully() async {
        let slug = "my-playlist-1-6"
        stubResponse(file: "patch_playlist_response", url: PlaylistEndpoint.update(slug).url)
        do {
            let playlist = try await sut.patchPlaylist(slug: slug, title: "Updated Title")
            XCTAssertFalse(playlist.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies removing playlist from favorites — server returns 204 without error
    func test_deletePlaylistFavorite_successfully() async {
        let slug = "test-playlist"
        stubResponse(url: PlaylistEndpoint.removeFavorite(slug).url, statusCode: 204)
        do {
            try await sut.deletePlaylistFavorite(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
