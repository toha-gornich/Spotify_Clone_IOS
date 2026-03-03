//
//  MockUserService.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//


import XCTest
@testable import Spotify_Clone_IOS

final class MockProfileService: ProfileScreenServiceProtocol {
    var shouldFail = false
    var mockUserMe = UserMe.empty()
    var mockUserMy = UserMy.empty()
    var mockPlaylists: [Playlist] = []
    var mockPlaylistDetail = PlaylistDetail.empty
    var mockFavoritePlaylists: [FavoritePlaylistItem] = []
    var mockFollowers: [User] = []
    var mockFollowing: [User] = []
    var mockAlbumsMy: [AlbumMy] = []
    var mockTracksMy: [TracksMy] = []
    var mockLicenses: [License] = []

    // MARK: - User

    func getUserMe() async throws -> UserMe {
        if shouldFail { throw APError.invalidData }
        return mockUserMe
    }

    func getUser(userId: String) async throws -> UserMe {
        if shouldFail { throw APError.invalidData }
        return mockUserMe
    }

    func getProfileMy() async throws -> UserMy {
        if shouldFail { throw APError.invalidData }
        return mockUserMy
    }

    func putUserMe(user: UpdateUserMe, imageData: Data?) async throws -> UserMy {
        if shouldFail { throw APError.unableToComplete }
        return mockUserMy
    }

    func deleteUserMe(password: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func getFollowers(userId: String) async throws -> [User] {
        if shouldFail { throw APError.invalidData }
        return mockFollowers
    }

    func getFollowing(userId: String) async throws -> [User] {
        if shouldFail { throw APError.invalidData }
        return mockFollowing
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
        return PatchPlaylistResponse.empty
    }

    // MARK: - Licenses

    func getLicenses() async throws -> [License] {
        if shouldFail { throw APError.invalidData }
        return mockLicenses
    }

    func getLicenseById(id: String) async throws -> License {
        if shouldFail { throw APError.invalidData }
        return mockLicenses.first ?? License.empty()
    }

    func postCreateLicense(name: String, text: String) async throws -> License {
        if shouldFail { throw APError.unableToComplete }
        return mockLicenses.first ?? License.empty()
    }

    func patchLicenseById(id: String, name: String?, text: String?) async throws -> License {
        if shouldFail { throw APError.unableToComplete }
        return mockLicenses.first ?? License.empty()
    }

    func deleteLicenseById(id: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    // MARK: - Albums

    func getAlbumsMy() async throws -> [AlbumMy] {
        if shouldFail { throw APError.invalidData }
        return mockAlbumsMy
    }

    func postCreateAlbum(title: String, description: String, releaseDate: String, isPrivate: Bool, imageData: Data?) async throws -> AlbumMy {
        if shouldFail { throw APError.unableToComplete }
        return mockAlbumsMy.first ?? AlbumMy.empty()
    }

    func deleteAlbumsMy(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    // MARK: - Tracks

    func getTracksMy() async throws -> [TracksMy] {
        if shouldFail { throw APError.invalidData }
        return mockTracksMy
    }

    func getTrackMyBySlug(slug: String) async throws -> TracksMyBySlug {
        if shouldFail { throw APError.invalidData }
        return TracksMyBySlug.empty()
    }

    func postCreateTrack(title: String, albumId: Int, genreId: Int, licenseId: Int, releaseDate: String, isPrivate: Bool, imageData: Data?, audioData: Data?) async throws -> Track {
        if shouldFail { throw APError.unableToComplete }
        return Track(
            id: 1,
            slug: "new-track",
            artist: ArtistTrack(
                id: 1,
                slug: "artist-slug",
                displayName: "Test Artist",
                image: "image.jpg",
                color: "#FFFFFF",
                isVerify: true
            ),
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

    func patchTrackMyBySlug(slug: String, title: String?, albumId: Int?, genreId: Int?, licenseId: Int?, releaseDate: String?, isPrivate: Bool?, imageData: Data?, audioData: Data?) async throws -> TracksMyBySlug {
        if shouldFail { throw APError.unableToComplete }
        return TracksMyBySlug.empty()
    }

    func patchTracksMy(slug: String, isPrivate: Bool, retryCount: Int) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func deleteTracksMy(slug: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }
}
