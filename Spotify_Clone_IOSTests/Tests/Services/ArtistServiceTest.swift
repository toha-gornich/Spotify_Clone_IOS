//
//  AuthServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 25.02.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class ArtistServiceTests: XCTestCase {
    
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
    
    /// Verifies successful artists list fetch — response contains at least one artist
    func test_getArtists_successfully() async {
        stubResponse(file: "artists_response", url: ArtistEndpoint.list.url)
        do {
            let response = try await sut.getArtists()
            XCTAssertFalse(response.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies artist fetch by slug — response slug matches requested slug
    func test_getArtistBySlug_successfully() async {
        let slug = "artist1"
        stubResponse(file: "artist_by_slug_response", url: ArtistEndpoint.bySlug(slug).url)
        do {
            let artist = try await sut.getArtistsBySlug(slug: slug)
            XCTAssertEqual(artist.slug, slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies favorite artists fetch — response contains at least one artist
    func test_getArtistsFavorite_successfully() async {
        stubResponse(file: "artists_favorite_response", url: ArtistEndpoint.favorite.url)
        do {
            let artists = try await sut.getArtistsFavorite()
            XCTAssertFalse(artists.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies adding artist to favorites — server returns 201 without error
    func test_postAddFavoriteArtist_successfully() async {
        let slug = "artist1"
        stubResponse(url: ArtistEndpoint.addFavorite(slug).url, statusCode: 201)
        do {
            try await sut.postAddFavoriteArtist(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that adding already favorited artist throws alreadyLiked error
    func test_postAddFavoriteArtist_alreadyLiked() async {
        let slug = "artist1"
        stubResponse(url: ArtistEndpoint.addFavorite(slug).url, statusCode: 409)
        do {
            try await sut.postAddFavoriteArtist(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? FavoriteError, .alreadyLiked)
        }
    }
    
    /// Verifies removing artist from favorites — server returns 204 without error
    func test_deleteArtistFavorite_successfully() async {
        let slug = "artist1"
        stubResponse(url: ArtistEndpoint.removeFavorite(slug).url, statusCode: 204)
        do {
            try await sut.deleteArtistFavorite(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies follow artist — server returns 200 without error
    func test_postFollowArtist_successfully() async {
        let userId = "123"
        stubResponse(url: UserEndpoint.follow(userId).url, statusCode: 200)
        do {
            try await sut.postFollowArtist(userId: userId)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that following already followed artist throws alreadyLiked error
    func test_postFollowArtist_alreadyFollowing() async {
        let userId = "123"
        stubResponse(url: UserEndpoint.follow(userId).url, statusCode: 409)
        do {
            try await sut.postFollowArtist(userId: userId)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? FavoriteError, .alreadyLiked)
        }
    }
    
    /// Verifies unfollow artist — server returns 200 without error
    func test_postUnfollowArtist_successfully() async {
        let userId = "123"
        stubResponse(url: UserEndpoint.unfollow(userId).url, statusCode: 200)
        do {
            try await sut.postUnfollowArtist(userId: userId)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies current artist profile fetch — response contains valid data
    func test_getArtistMe_successfully() async {
        stubResponse(file: "artist_me_response", url: ArtistEndpoint.me.url)
        do {
            let artist = try await sut.getArtistMe()
            XCTAssertFalse(artist.slug.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
