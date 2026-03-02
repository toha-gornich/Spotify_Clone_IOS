    //
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class TrackServiceTests: XCTestCase {
    
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
    
    /// Verifies successful tracks list fetch — response contains at least one track
    func test_getTracks_successfully() async {
        stubResponse(file: "tracks_response", url: TrackEndpoint.tracks.url)
        do {
            let tracks = try await sut.getTracks()
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on tracks fetch throws invalidResponse
    func test_getTracks_serverError() async {
        stubResponse(url: TrackEndpoint.tracks.url, statusCode: 500)
        do {
            _ = try await sut.getTracks()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies track fetch by slug — response contains valid track data
    func test_getTrackBySlug_successfully() async {
        let slug = "i-was-never-there"
        stubResponse(file: "track_detail_response", url: TrackEndpoint.bySlug(slug).url)
        do {
            let track = try await sut.getTrackBySlug(slug: slug)
            XCTAssertFalse(track.slug.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies tracks fetch by artist slug — response contains at least one track
    func test_getTracksBySlugArtist_successfully() async {
        let slug = "artist1"
        stubResponse(file: "tracks_response", url: TrackEndpoint.byArtist(slug).url)
        do {
            let tracks = try await sut.getTracksBySlugArtist(slug: slug)
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies tracks fetch by genre slug — response contains at least one track
    func test_getTracksBySlugGenre_successfully() async {
        let slug = "pop"
        stubResponse(file: "tracks_response", url: TrackEndpoint.byGenre(slug).url)
        do {
            let tracks = try await sut.getTracksBySlugGenre(slug: slug)
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies tracks fetch by album slug — response contains at least one track
    func test_getTracksBySlugAlbum_successfully() async {
        let slug = "i-was-never-there"
        stubResponse(file: "tracks_response", url: TrackEndpoint.byAlbum(slug).url)
        do {
            let tracks = try await sut.getTracksBySlugAlbum(slug: slug)
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies liked tracks fetch — response contains at least one track
    func test_getTracksLiked_successfully() async {
        stubResponse(file: "tracks_response", url: TrackEndpoint.liked.url)
        do {
            let tracks = try await sut.getTracksLiked()
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful track like — server returns 200 without error
    func test_postLikeTrack_successfully() async {
        let slug = "i-was-never-there"
        stubResponse(url: TrackEndpoint.like(slug).url, statusCode: 200)
        do {
            try await sut.postLikeTrack(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that liking already liked track throws alreadyLiked error
    func test_postLikeTrack_alreadyLiked() async {
        let slug = "i-was-never-there"
        stubResponse(url: TrackEndpoint.like(slug).url, statusCode: 409)
        do {
            try await sut.postLikeTrack(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? FavoriteError, .alreadyLiked)
        }
    }
    
    /// Verifies successful track unlike — server returns 204 without error
    func test_deleteTrackLike_successfully() async {
        let slug = "i-was-never-there"
        stubResponse(url: TrackEndpoint.unlike(slug).url, statusCode: 204)
        do {
            try await sut.deleteTrackLike(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that unliking non-liked track throws invalidResponse
    func test_deleteTrackLike_notFound() async {
        let slug = "i-was-never-there"
        stubResponse(url: TrackEndpoint.unlike(slug).url, statusCode: 404)
        do {
            try await sut.deleteTrackLike(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
}
