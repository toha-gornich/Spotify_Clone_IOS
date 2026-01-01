//
//  TrackDetailTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class TrackDetailTests: XCTestCase {
    
    func testTrackDetailDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "test-track",
            "artist": {
                "id": 1,
                "slug": "test-artist",
                "display_name": "Test Artist",
                "image": "test.jpg",
                "color": "#000000",
                "is_verify": true
            },
            "title": "Test Track",
            "file": "test.mp3",
            "duration": "00:03:45.000000",
            "image": "track.jpg",
            "color": "#333333",
            "plays_count": 1000,
            "genre": {
                "id": 1,
                "slug": "rock",
                "name": "Rock",
                "image": "rock.jpg",
                "color": "#ff0000"
            },
            "album": {
                "id": 1,
                "slug": "test-album",
                "title": "Test Album",
                "image": "album.jpg",
                "color": "#000000",
                "is_private": false
            },
            "created_at": "2024-01-15T10:30:00Z",
            "updated_at": "2024-01-15T10:30:00Z",
            "is_liked": true,
            "lyrics": "Test lyrics"
        }
        """
        
        let data = json.data(using: .utf8)!
        let trackDetail = try JSONDecoder().decode(TrackDetail.self, from: data)
        
        XCTAssertEqual(trackDetail.id, 1)
        XCTAssertEqual(trackDetail.isLiked, true)
        XCTAssertTrue(trackDetail.hasLyrics)
        XCTAssertEqual(trackDetail.lyrics, "Test lyrics")
    }
    
    func testTrackDetailToTrackConversion() {
        let trackDetail = MockData.trackDetail
        let track = trackDetail.toTrack()
        
        XCTAssertEqual(track.id, trackDetail.id)
        XCTAssertEqual(track.slug, trackDetail.slug)
        XCTAssertEqual(track.title, trackDetail.title)
    }
}