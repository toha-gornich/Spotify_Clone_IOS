//
//  ArtistTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class ArtistTests: XCTestCase {
    
    func testArtistDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "test-artist",
            "user": {
                "id": 1,
                "display_name": "Test User",
                "type_profile": "Artist",
                "artist_slug": "test-artist",
                "image": "user.jpg",
                "followers_count": 100,
                "is_premium": false
            },
            "first_name": "John",
            "last_name": "Doe",
            "display_name": "Test Artist",
            "image": "artist.jpg",
            "color": "#000000",
            "track_slug": "test-track",
            "artist_listeners": 1000,
            "is_verify": true
        }
        """
        
        let data = json.data(using: .utf8)!
        let artist = try JSONDecoder().decode(Artist.self, from: data)
        
        XCTAssertEqual(artist.id, 1)
        XCTAssertEqual(artist.displayName, "Test Artist")
        XCTAssertTrue(artist.isVerify)
        XCTAssertEqual(artist.fullName, "John Doe")
    }
    
    func testArtistHasTrack() {
        let artistWithTrack = Artist(
            id: 1,
            slug: "test",
            user: User.empty,
            firstName: "John",
            lastName: "Doe",
            displayName: "Test",
            image: "",
            color: "",
            trackSlug: "test-track",
            artistListeners: 100,
            isVerify: false
        )
        
        let artistWithoutTrack = Artist(
            id: 2,
            slug: "test2",
            user: User.empty,
            firstName: "Jane",
            lastName: "Doe",
            displayName: "Test2",
            image: "",
            color: "",
            trackSlug: nil,
            artistListeners: 100,
            isVerify: false
        )
        
        XCTAssertTrue(artistWithTrack.hasTrack)
        XCTAssertFalse(artistWithoutTrack.hasTrack)
    }
    
    func testArtistEmpty() {
        let artist = Artist.empty
        XCTAssertEqual(artist.id, -1)
        XCTAssertEqual(artist.displayName, "")
    }
}