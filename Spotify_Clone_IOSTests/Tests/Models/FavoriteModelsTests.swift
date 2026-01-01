//
//  FavoriteModelsTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class FavoriteModelsTests: XCTestCase {
    
    func testFavoriteAlbumItemToAlbum() {
        let album = Album.empty
        let favoriteItem = FavoriteAlbumItem(
            id: 1,
            album: album,
            createdAt: "2024-01-01T00:00:00Z",
            updatedAt: "2024-01-01T00:00:00Z"
        )
        
        let convertedAlbum = favoriteItem.toAlbum()
        XCTAssertEqual(convertedAlbum.id, album.id)
    }
    
    func testFavoriteArtistItemToArtist() {
        let artist = ArtistTrack(
            id: 1,
            slug: "test",
            displayName: "Test Artist",
            image: "",
            color: "",
            isVerify: false
        )
        
        let favoriteItem = FavoriteArtistItem(
            id: 1,
            artist: artist,
            createdAt: "2024-01-01T00:00:00Z",
            updatedAt: "2024-01-01T00:00:00Z"
        )
        
        let convertedArtist = favoriteItem.toArtist()
        XCTAssertEqual(convertedArtist.id, artist.id)
        XCTAssertEqual(convertedArtist.displayName, artist.displayName)
    }
    
    func testFavoritePlaylistItemToPlaylist() {
        let playlist = Playlist.empty
        let favoriteItem = FavoritePlaylistItem(
            id: 1,
            playlist: playlist,
            createdAt: "2024-01-01T00:00:00Z",
            updatedAt: "2024-01-01T00:00:00Z"
        )
        
        let convertedPlaylist = favoriteItem.toPlaylist()
        XCTAssertEqual(convertedPlaylist.id, playlist.id)
    }
}