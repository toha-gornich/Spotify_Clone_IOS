//
//  AlbumTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class AlbumTests: XCTestCase {
    
    func testAlbumDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "test-album",
            "title": "Test Album",
            "description": "Test description",
            "artist": {
                "id": 1,
                "slug": "test-artist",
                "display_name": "Test Artist",
                "image": "artist.jpg",
                "color": "#000000",
                "is_verify": true
            },
            "track_slug": "test-track",
            "image": "album.jpg",
            "color": "#333333",
            "is_private": false,
            "release_date": "2024-01-01",
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let album = try JSONDecoder().decode(Album.self, from: data)
        
        XCTAssertEqual(album.id, 1)
        XCTAssertEqual(album.title, "Test Album")
        XCTAssertEqual(album.artist.displayName, "Test Artist")
        XCTAssertFalse(album.isPrivate)
    }
    
    func testAlbumEmpty() {
        let album = Album.empty
        XCTAssertEqual(album.id, 0)
        XCTAssertEqual(album.title, "")
    }
}