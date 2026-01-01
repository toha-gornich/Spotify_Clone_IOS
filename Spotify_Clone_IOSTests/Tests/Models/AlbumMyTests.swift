//
//  AlbumMyTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class AlbumMyTests: XCTestCase {
    
    func testAlbumMyListenersFormatting() {
        let album = AlbumMy(
            id: 1,
            slug: "test",
            title: "Test",
            description: "Test",
            artist: ArtistTracksMy(id: 1, slug: "artist", displayName: "Artist", image: "", color: "", isVerify: false),
            albumListeners: 1_500_000,
            image: "",
            color: "",
            tracks: [],
            duration: "",
            isPrivate: false,
            releaseDate: "2024",
            createdAt: "",
            updatedAt: ""
        )
        
        XCTAssertEqual(album.formattedListenersCount, "1.5M")
    }
    
    func testAlbumMyReleaseDateFormatting() {
        let album = AlbumMy(
            id: 1,
            slug: "test",
            title: "Test",
            description: "Test",
            artist: ArtistTracksMy(id: 1, slug: "artist", displayName: "Artist", image: "", color: "", isVerify: false),
            albumListeners: 100,
            image: "",
            color: "",
            tracks: [],
            duration: "",
            isPrivate: false,
            releaseDate: "2024-03-15",
            createdAt: "",
            updatedAt: ""
        )
        
        XCTAssertEqual(album.formattedReleaseDate, "Mar 15, 2024")
        XCTAssertEqual(album.shortReleaseDate, "2024")
    }
    
    func testAlbumMyTracksCount() {
        let tracks = [MockData.track, MockData.track, MockData.track]
        let album = AlbumMy(
            id: 1,
            slug: "test",
            title: "Test",
            description: "Test",
            artist: ArtistTracksMy(id: 1, slug: "artist", displayName: "Artist", image: "", color: "", isVerify: false),
            albumListeners: 100,
            image: "",
            color: "",
            tracks: tracks,
            duration: "",
            isPrivate: false,
            releaseDate: "2024",
            createdAt: "",
            updatedAt: ""
        )
        
        XCTAssertEqual(album.tracksCount, 3)
    }
}