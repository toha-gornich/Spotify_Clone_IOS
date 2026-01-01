//
//  PlaylistTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class PlaylistTests: XCTestCase {
    
    func testPlaylistDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "test-playlist",
            "title": "Test Playlist",
            "image": "playlist.jpg",
            "color": "#000000",
            "track_slug": "test-track",
            "user": {
                "id": 1,
                "display_name": "Test User",
                "type_profile": "User",
                "artist_slug": null,
                "image": "user.jpg",
                "followers_count": 0,
                "is_premium": false
            },
            "genre": {
                "id": 1,
                "slug": "rock",
                "name": "Rock",
                "image": "rock.jpg",
                "color": "#ff0000"
            },
            "is_private": false
        }
        """
        
        let data = json.data(using: .utf8)!
        let playlist = try JSONDecoder().decode(Playlist.self, from: data)
        
        XCTAssertEqual(playlist.id, 1)
        XCTAssertEqual(playlist.title, "Test Playlist")
        XCTAssertFalse(playlist.isPrivate)
        XCTAssertNotNil(playlist.genre)
    }
    
    func testPlaylistEmpty() {
        let playlist = Playlist.empty
        XCTAssertEqual(playlist.id, 0)
        XCTAssertEqual(playlist.title, "")
    }
}