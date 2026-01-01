//
//  PlaylistDetailTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class PlaylistDetailTests: XCTestCase {
    
    func testPlaylistDetailDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "test-playlist",
            "title": "Test Playlist",
            "description": "Test description",
            "image": "playlist.jpg",
            "color": "#000000",
            "user": {
                "id": 1,
                "display_name": "Test User",
                "type_profile": "User",
                "artist_slug": null,
                "image": "user.jpg",
                "followers_count": 0,
                "is_premium": false
            },
            "tracks": [],
            "genre": null,
            "release_date": "2024-01-01",
            "is_private": false,
            "duration": "00:15:30",
            "favorite_count": 10,
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let playlistDetail = try JSONDecoder().decode(PlaylistDetail.self, from: data)
        
        XCTAssertEqual(playlistDetail.id, 1)
        XCTAssertEqual(playlistDetail.title, "Test Playlist")
        XCTAssertEqual(playlistDetail.favoriteCount, 10)
    }
}