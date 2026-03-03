//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 02.03.2026.
//
import XCTest
@testable import Spotify_Clone_IOS

class MockArtistService: AlbumArtistServiceProtocol {
    var shouldFail = false
    var mockArtist: Artist = Artist.empty
    var mockArtists: [Artist] = []
    var mockTracks: [Track] = []
    var mockAlbums: [Album] = []
    var mockFavoriteArtists: [FavoriteArtistItem] = []
    var mockFavoriteAlbums: [FavoriteAlbumItem] = []
    var mockTrackDetail: TrackDetail = MockData.trackDetail

    // MARK: - Albums

    func getAlbums() async throws -> [Album] {
        if shouldFail { throw APError.invalidData }
        return mockAlbums
    }

    func getAlbumBySlug(slug: String) async throws -> Album {
        if shouldFail { throw APError.invalidData }
        return mockAlbums.first ?? Album.empty
    }

    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        if shouldFail { throw APError.invalidData }
        return mockAlbums
    }

    func getAlbumsFavorite() async throws -> [FavoriteAlbumItem] {
        if shouldFail { throw APError.invalidData }
        return mockFavoriteAlbums
    }

    func postAddFavoriteAlbum(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deleteAlbumsFavorite(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    // MARK: - Artists

    func getArtists() async throws -> [Artist] {
        if shouldFail { throw APError.invalidData }
        return mockArtists
    }

    func getArtistsBySlug(slug: String) async throws -> Artist {
        if shouldFail { throw APError.invalidData }
        return mockArtist
    }

    func getArtistsFavorite() async throws -> [FavoriteArtistItem] {
        if shouldFail { throw APError.invalidData }
        return mockFavoriteArtists
    }

    func getArtistMe() async throws -> Artist {
        if shouldFail { throw APError.invalidData }
        return mockArtist
    }

    func putArtistMe(artist: UpdateArtist, imageData: Data?) async throws -> Artist {
        if shouldFail { throw APError.unableToComplete }
        return mockArtist
    }

    func postFollowArtist(userId: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func postUnfollowArtist(userId: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func postAddFavoriteArtist(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deleteArtistFavorite(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
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
