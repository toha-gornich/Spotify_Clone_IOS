//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 02.03.2026.
//
import XCTest
@testable import Spotify_Clone_IOS

class MockSearchService: SearchServiceProtocol {
    var shouldFail = false
    var mockTracksResponse = TracksResponse(count: 0, next: nil, previous: nil, results: [])
    var mockArtistsResponse = ArtistResponse(count: 0, next: nil, previous: nil, results: [])
    var mockAlbumsResponse = AlbumResponse(count: 0, next: nil, previous: nil, results: [])
    var mockPlaylistsResponse = PlaylistResponse(count: 0, next: nil, previous: nil, results: [])
    var mockProfilesResponse = UserResponse(count: 0, next: nil, previous: nil, results: [])

    func searchTracks(searchText: String, page: Int) async throws -> TracksResponse {
        if shouldFail { throw APError.invalidData }
        return mockTracksResponse
    }

    func searchArtists(searchText: String, page: Int) async throws -> ArtistResponse {
        if shouldFail { throw APError.invalidData }
        return mockArtistsResponse
    }

    func searchAlbums(searchText: String, page: Int) async throws -> AlbumResponse {
        if shouldFail { throw APError.invalidData }
        return mockAlbumsResponse
    }

    func searchPlaylists(searchText: String, page: Int) async throws -> PlaylistResponse {
        if shouldFail { throw APError.invalidData }
        return mockPlaylistsResponse
    }

    func searchProfiles(searchText: String, page: Int) async throws -> UserResponse {
        if shouldFail { throw APError.invalidData }
        return mockProfilesResponse
    }
}


