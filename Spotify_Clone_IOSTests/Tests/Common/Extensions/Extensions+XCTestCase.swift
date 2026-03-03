//
//  Extensions+XCTestCase.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 28.02.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

extension XCTestCase {
    
    func stubResponse(file: String? = nil, url: URL, statusCode: Int = 200) {
        if let file = file {
            guard let path = Bundle(for: type(of: self))
                .url(forResource: file, withExtension: "json"),
                  let data = try? Data(contentsOf: path)
            else {
                XCTFail("Missing \(file).json in test bundle")
                return
            }
            MockURLProtocol.stubResponseData = data
        }
        
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}

// TestHelpers
extension XCTestCase {
    
    func makeMockArtist(slug: String) -> Artist {
        Artist(
            id: 1,
            slug: slug,
            user: User(
                id: 1,
                displayName: "Test User",
                typeProfile: "artist",
                artistSlug: slug,
                image: "user.jpg",
                followersCount: 100,
                isPremium: false
            ),
            firstName: "Test",
            lastName: "Artist",
            displayName: "Test Artist",
            image: "artist.jpg",
            color: "#FFFFFF",
            trackSlug: "track-slug",
            artistListeners: 1000,
            isVerify: true
        )
    }

    func makeMockArtistTrack(slug: String) -> ArtistTrack {
        ArtistTrack(
            id: 1,
            slug: slug,
            displayName: "Test Artist",
            image: "artist.jpg",
            color: "#FFFFFF",
            isVerify: true
        )
    }

    func makeFavoriteArtistItem(slug: String) -> FavoriteArtistItem {
        FavoriteArtistItem(
            id: 1,
            artist: makeMockArtistTrack(slug: slug),
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }

    func makeMockTrack(slug: String) -> Track {
        Track(
            id: 1,
            slug: slug,
            artist: makeMockArtistTrack(slug: "artist-slug"),
            title: "Test Title",
            file: "file.mp3",
            duration: "3:00",
            image: "image.jpg",
            color: "#FFFFFF",
            playsCount: 0,
            genre: Genre(id: 1, slug: "pop", name: "Pop", image: "genre.jpg", color: "#000000"),
            album: AlbumTrack(id: 1, slug: "album-slug", title: "Test Album", image: "album.jpg", color: "#000000", isPrivate: false)
        )
    }
    
    func makeMockAlbum(slug: String) -> Album {
        Album(
            id: 1,
            slug: slug,
            title: "Test Album",
            description: "Test Description",
            artist: ArtistAlbum(
                id: 1,
                slug: "artist-slug",
                displayName: "Test Artist",
                image: "artist.jpg",
                color: "#FFFFFF",
                isVerify: true
            ),
            trackSlug: nil,
            image: "album.jpg",
            color: "#FFFFFF",
            isPrivate: false,
            releaseDate: "2024-01-01",
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }

    func makeFavoriteAlbumItem(slug: String) -> FavoriteAlbumItem {
        FavoriteAlbumItem(
            id: 1,
            album: makeMockAlbum(slug: slug),
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }
    
    func makeMockPlaylist(slug: String) -> Playlist {
        Playlist(
            id: 1,
            slug: slug,
            title: "Test Playlist",
            image: "playlist.jpg",
            color: "#FFFFFF",
            trackSlug: nil,
            user: User(
                id: 1,
                displayName: "Test User",
                typeProfile: "user",
                artistSlug: nil,
                image: "user.jpg",
                followersCount: 0,
                isPremium: false
            ),
            genre: nil,
            isPrivate: false
        )
    }

    func makeFavoritePlaylistItem(slug: String) -> FavoritePlaylistItem {
        FavoritePlaylistItem(
            id: 1,
            playlist: makeMockPlaylist(slug: slug),
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }

    func makeMockPlaylistDetail(slug: String) -> PlaylistDetail {
        PlaylistDetail(
            id: 1,
            slug: slug,
            title: "Test Playlist",
            description: "Test Description",
            image: "playlist.jpg",
            color: "#FFFFFF",
            user: User(
                id: 1,
                displayName: "Test User",
                typeProfile: "user",
                artistSlug: nil,
                image: "user.jpg",
                followersCount: 0,
                isPremium: false
            ),
            tracks: [],
            genre: nil,
            releaseDate: "2024-01-01",
            isPrivate: false,
            duration: "3:00",
            favoriteCount: 0,
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }

    func makeMockGenre(slug: String) -> Genre {
        Genre(
            id: 1,
            slug: slug,
            name: "Test Genre",
            image: "genre.jpg",
            color: "#FFFFFF"
        )
    }

    func makeMockPatchResponse(slug: String) -> PatchPlaylistResponse {
        PatchPlaylistResponse(
            id: 1,
            slug: slug,
            title: "Test Playlist",
            description: "Test Description",
            image: "playlist.jpg",
            genre: nil,
            releaseDate: "2024-01-01",
            isPrivate: false
        )
    }
    
    func makeMockUserMy() -> UserMy {
        UserMy(
            id: 1,
            email: "test@test.com",
            displayName: "Test User",
            gender: "male",
            country: "UA",
            image: "user.jpg",
            typeProfile: "user",
            isPremium: false
        )
    }

    func makeMockUserMe() -> UserMe {
        UserMe(
            id: 1,
            email: "test@test.com",
            displayName: "Test User",
            gender: "male",
            country: "UA",
            image: "user.jpg",
            color: "#FFFFFF",
            typeProfile: "user",
            artistSlug: nil,
            isPremium: false,
            followersCount: 0,
            followingCount: 0,
            playlistsCount: 0
        )
    }

    func makeMockAlbumMy(slug: String) -> AlbumMy {
        AlbumMy(
            id: 1,
            slug: slug,
            title: "Test Album",
            description: "Test Description",
            artist: ArtistTracksMy.empty(),
            albumListeners: 100,
            image: "album.jpg",
            color: "#FFFFFF",
            tracks: [],
            duration: "3:00",
            isPrivate: false,
            releaseDate: "2024-01-01",
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }


    func makeMockLicense() -> License {
        License(
            id: 1,
            artist: ArtistTracksMy.empty(),
            name: "Test License",
            text: "Test License Text"
        )
    }


    func makeMockTrackMy(slug: String) -> TracksMy {
        TracksMy(
            id: 1,
            slug: slug,
            artist: ArtistTracksMy.empty(),
            title: "Test Track",
            duration: "3:00",
            image: "track.jpg",
            color: "#FFFFFF",
            license: makeMockLicense(),
            genre: Genre.empty(),
            album: AlbumTrack.empty(),
            file: "track.mp3",
            playsCount: 0,
            downloadsCount: 0,
            likesCount: 0,
            userOfLikes: [],
            isPrivate: false,
            releaseDate: "2024-01-01",
            createdAt: "2024-01-01",
            updatedAt: "2024-01-01"
        )
    }
}
