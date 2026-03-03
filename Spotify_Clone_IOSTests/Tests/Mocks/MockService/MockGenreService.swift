//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 02.03.2026.
//
import XCTest
@testable import Spotify_Clone_IOS

class MockGenreService: GenreScreenServiceProtocol {
    var shouldFail = false
    var mockGenres: [Genre] = []
    var mockGenre: Genre = Genre.empty()
    var mockTracks: [Track] = []
    var mockPlaylists: [Playlist] = []
    var mockFavoritePlaylists: [FavoritePlaylistItem] = []
    var mockPlaylistDetail: PlaylistDetail = PlaylistDetail.empty
    var mockTrackDetail: TrackDetail = MockData.trackDetail
    var mockPatchResponse: PatchPlaylistResponse = PatchPlaylistResponse.empty

    // MARK: - Genres

    func getGenres() async throws -> [Genre] {
        if shouldFail { throw APError.invalidData }
        return mockGenres
    }

    func getGenreBySlug(slug: String) async throws -> Genre {
        if shouldFail { throw APError.invalidData }
        return mockGenre
    }

    // MARK: - Playlists

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

    // MARK: - Tracks

    func getTracks() async throws -> [Track] {
        if shouldFail { throw APError.invalidData }
        return mockTracks
    }

    func getTrackBySlug(slug: String) async throws -> TrackDetail {
        if shouldFail { throw APError.invalidData }
        return mockTrackDetail
    }

    func getTracksBySlugArtist(slug: String) async throws -> [Track] {
        if shouldFail { throw APError.invalidData }
        return mockTracks
    }

    func getTracksBySlugGenre(slug: String) async throws -> [Track] {
        if shouldFail { throw APError.invalidData }
        return mockTracks
    }

    func getTracksBySlugAlbum(slug: String) async throws -> [Track] {
        if shouldFail { throw APError.invalidData }
        return mockTracks
    }

    func getTracksLiked() async throws -> [Track] {
        if shouldFail { throw APError.invalidData }
        return mockTracks
    }

    func postLikeTrack(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deleteTrackLike(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }
}
