//
//  MockUserService.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//


import XCTest
@testable import Spotify_Clone_IOS

class MockPlaylistService: PlaylistServiceProtocol {
    var shouldFail = false
    var mockPlaylists: [Playlist] = []
    var mockPlaylistDetail = PlaylistDetail.empty
    var mockFavoritePlaylists: [FavoritePlaylistItem] = []
    var mockPatchResponse = PatchPlaylistResponse.empty

    func getPlaylists() async throws -> [Playlist] {
        if shouldFail { throw APError.invalidData }
        return mockPlaylists
    }

    func getPlaylistsByIdUser(idUser: Int) async throws -> [Playlist] {
        if shouldFail { throw APError.invalidData }
        return mockPlaylists
    }

    func getPlaylistsBySlug(slug: String) async throws -> PlaylistDetail {
        if shouldFail { throw APError.invalidData }
        return mockPlaylistDetail
    }

    func getPlaylistsBySlugGenre(slug: String) async throws -> [Playlist] {
        if shouldFail { throw APError.invalidData }
        return mockPlaylists
    }

    func getPlaylistsFavorite() async throws -> [FavoritePlaylistItem] {
        if shouldFail { throw APError.invalidData }
        return mockFavoritePlaylists
    }

    func postAddFavoritePlaylist(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deletePlaylistFavorite(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deletePlaylist(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func postMyPlaylist() async throws -> PlaylistDetail {
        if shouldFail { throw APError.unableToComplete }
        return mockPlaylistDetail
    }

    func postTrackToPlaylist(slug: String, trackSlug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deleteTrackFromPlaylist(slug: String, trackSlug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func patchPlaylist(slug: String, title: String?, description: String?, isPrivate: Bool?, imageData: Data?) async throws -> PatchPlaylistResponse {
        if shouldFail { throw APError.unableToComplete }
        return mockPatchResponse
    }
}
