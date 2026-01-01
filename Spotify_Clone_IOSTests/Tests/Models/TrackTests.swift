//
//  TrackTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class TrackTests: XCTestCase {
    
    func testTrackDecoding() throws {
        let json = """
        {
            "id": 52,
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
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let track = try JSONDecoder().decode(Track.self, from: data)
        
        XCTAssertEqual(track.id, 52)
        XCTAssertEqual(track.slug, "test-track")
        XCTAssertEqual(track.title, "Test Track")
        XCTAssertEqual(track.playsCount, 1000)
        XCTAssertEqual(track.artist.displayName, "Test Artist")
    }
    
    func testTrackDurationConversion() {
        let track = Track(
            id: 1,
            slug: "test",
            artist: ArtistTrack(id: 1, slug: "artist", displayName: "Artist", image: "", color: "", isVerify: false),
            title: "Test",
            file: "test.mp3",
            duration: "00:03:45.000000",
            image: "test.jpg",
            color: "#000000",
            playsCount: 100,
            genre: Genre(id: 1, slug: "rock", name: "Rock", image: "", color: ""),
            album: AlbumTrack(id: 1, slug: "album", title: "Album", image: "", color: "", isPrivate: false)
        )
        
        XCTAssertEqual(track.durationInSeconds, 225) // 3*60 + 45 = 225
        XCTAssertEqual(track.formattedDuration, "3:45")
    }
    
    func testTrackPlaysCountFormatting() {
        let track = Track(
            id: 1,
            slug: "test",
            artist: ArtistTrack(id: 1, slug: "artist", displayName: "Artist", image: "", color: "", isVerify: false),
            title: "Test",
            file: "test.mp3",
            duration: "00:03:45.000000",
            image: "test.jpg",
            color: "#000000",
            playsCount: 1_500_000,
            genre: Genre(id: 1, slug: "rock", name: "Rock", image: "", color: ""),
            album: AlbumTrack(id: 1, slug: "album", title: "Album", image: "", color: "", isPrivate: false)
        )
        
        XCTAssertEqual(track.formattedPlaysCount, "1.5M")
    }
    
    func testTrackEmptyInitialization() {
        let track = MockData.track
        XCTAssertNotNil(track)
        XCTAssertEqual(track.id, 52)
    }
}