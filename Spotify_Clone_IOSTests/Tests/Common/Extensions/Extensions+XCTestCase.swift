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
    
}
