//
//  ServiceProtocols.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation
import UIKit

// MARK: - Authentication Service Protocol
protocol AuthServiceProtocol {
    func postRegUser(regUser: RegUser) async throws -> RegUserResponse
    func postLogin(loginRequest: LoginRequest) async throws -> LoginResponse
    func postVerifyToken(tokenVerifyRequest: TokenVerifyRequest) async throws
    func postActivateAccount(activationRequest: AccountActivationRequest) async throws
}

// MARK: - User Service Protocol
protocol UserServiceProtocol {
    func getUserMe() async throws -> UserMe
    func getUser(userId: String) async throws -> UserMe
    func getProfileMy() async throws -> UserMy
    func putUserMe(user: UpdateUserMe, imageData: Data?) async throws -> UserMy
    func deleteUserMe(password: String) async throws
    func getFollowers(userId: String) async throws -> [User]
    func getFollowing(userId: String) async throws -> [User]
}

// MARK: - Track Service Protocol
protocol TrackServiceProtocol {
    func getTracks() async throws -> [Track]
    func getTrackBySlug(slug: String) async throws -> TrackDetail
    func getTracksBySlugArtist(slug: String) async throws -> [Track]
    func getTracksBySlugGenre(slug: String) async throws -> [Track]
    func getTracksBySlugAlbum(slug: String) async throws -> [Track]
//    func getTrackFavorites() async throws
    func getTracksLiked() async throws -> [Track]
    func postLikeTrack(slug: String) async throws
    func deleteTrackLike(slug: String) async throws
    
}

// MARK: - My Tracks Service Protocol 
protocol MyTracksServiceProtocol {
    func getTracksMy() async throws -> [TracksMy]
    func getTrackMyBySlug(slug: String) async throws -> TracksMyBySlug
    func postCreateTrack(
        title: String,
        albumId: Int,
        genreId: Int,
        licenseId: Int,
        releaseDate: String,
        isPrivate: Bool,
        imageData: Data?,
        audioData: Data?
    ) async throws -> Track
    func patchTrackMyBySlug(
        slug: String,
        title: String?,
        albumId: Int?,
        genreId: Int?,
        licenseId: Int?,
        releaseDate: String?,
        isPrivate: Bool?,
        imageData: Data?,
        audioData: Data?
    ) async throws -> TracksMyBySlug
    func patchTracksMy(slug: String, isPrivate: Bool, retryCount: Int) async throws
    func deleteTracksMy(slug: String) async throws
}

// MARK: - Artist Service Protocol
protocol ArtistServiceProtocol {
    func getArtists() async throws -> [Artist]
    func getArtistsBySlug(slug: String) async throws -> Artist
    func getArtistsFavorite() async throws -> [FavoriteArtistItem]
    func getArtistMe() async throws -> Artist
    func putArtistMe(artist: UpdateArtist, imageData: Data?) async throws -> Artist
    func postFollowArtist(userId: String) async throws
    func postUnfollowArtist(userId: String) async throws
    func postAddFavoriteArtist(slug: String) async throws
    func deleteArtistFavorite(slug: String) async throws
}

// MARK: - License Service Protocol
protocol LicenseServiceProtocol {
    func getLicenses() async throws -> [License]
    func getLicenseById(id: String) async throws -> License
    func postCreateLicense(name: String, text: String) async throws -> License
    func patchLicenseById(id: String, name: String?, text: String?) async throws -> License
    func deleteLicenseById(id: String) async throws
}

// MARK: - Album Service Protocol
protocol AlbumServiceProtocol {
    func getAlbums() async throws -> [Album]
    func getAlbumBySlug(slug: String) async throws -> Album
    func getAlbumsBySlugArtist(slug: String) async throws -> [Album]
    func getAlbumsFavorite() async throws -> [FavoriteAlbumItem]
    func postAddFavoriteAlbum(slug: String) async throws
    func deleteAlbumsFavorite(slug: String) async throws
}

// MARK: - My Albums Service Protocol
protocol MyAlbumsServiceProtocol {
    func getAlbumsMy() async throws -> [AlbumMy]
    func postCreateAlbum(
        title: String,
        description: String,
        releaseDate: String,
        isPrivate: Bool,
        imageData: Data?
    ) async throws -> AlbumMy
    func patchAlbumBySlugMy(
        slug: String,
        title: String?,
        description: String?,
        releaseDate: String?,
        isPrivate: Bool?,
        imageData: Data?
    ) async throws -> Album
    func deleteAlbumsMy(slug: String) async throws
}

// MARK: - Playlist Service Protocol
protocol PlaylistServiceProtocol {
    func getPlaylists() async throws -> [Playlist]
    func getPlaylistsByIdUser(idUser: Int) async throws -> [Playlist]
    func getPlaylistsBySlug(slug: String) async throws -> PlaylistDetail
    func getPlaylistsBySlugGenre(slug: String) async throws -> [Playlist]
    func getPlaylistsFavorite() async throws -> [FavoritePlaylistItem]
    func postAddFavoritePlaylist(slug: String) async throws
    func deletePlaylistFavorite(slug: String) async throws
    func deletePlaylist(slug: String) async throws
    func postMyPlaylist() async throws -> PlaylistDetail
    func postTrackToPlaylist(slug: String, trackSlug: String) async throws
    func deleteTrackFromPlaylist(slug: String, trackSlug: String) async throws
    func patchPlaylist(
        slug: String,
        title: String?,
        description: String?,
        isPrivate: Bool?,
        imageData: Data?
    ) async throws -> PatchPlaylistResponse
}

// MARK: - Genre Service Protocol
protocol GenreServiceProtocol {
    func getGenres() async throws -> [Genre]
    func getGenreBySlug(slug: String) async throws -> Genre
}

// MARK: - Search Service Protocol
protocol SearchServiceProtocol {
    func searchTracks(searchText: String, page: Int) async throws -> TracksResponse
    func searchArtists(searchText: String, page: Int) async throws -> ArtistResponse
    func searchAlbums(searchText: String, page: Int) async throws -> AlbumResponse
    func searchPlaylists(searchText: String, page: Int) async throws -> PlaylistResponse
    func searchProfiles(searchText: String, page: Int) async throws -> UserResponse
}

// MARK: - Image Service Protocol
protocol ImageServiceProtocol {
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void)
}

// MARK: - Composite protocols


typealias PlaylistsServiceProtocol = PlaylistServiceProtocol & UserServiceProtocol
typealias LibraryServiceProtocol = PlaylistServiceProtocol & ArtistServiceProtocol & AlbumServiceProtocol & PlaylistServiceProtocol & UserServiceProtocol & TrackServiceProtocol

typealias HomeServiceProtocol = TrackServiceProtocol & PlaylistServiceProtocol & ArtistServiceProtocol & AlbumServiceProtocol & UserServiceProtocol

typealias AlbumArtistServiceProtocol = AlbumServiceProtocol & TrackServiceProtocol & ArtistServiceProtocol

typealias CreateAlbumServiceProtocol = GenreServiceProtocol & MyAlbumsServiceProtocol

typealias EditAlbumServiceProtocol = MyAlbumsServiceProtocol & AlbumServiceProtocol

typealias CreateTrackServiceProtocol = GenreServiceProtocol & MyAlbumsServiceProtocol & MyTracksServiceProtocol & LicenseServiceProtocol

typealias ProfileServiceProtocol = UserServiceProtocol & MyTracksServiceProtocol & MyAlbumsServiceProtocol & LicenseServiceProtocol

typealias GenreScreenServiceProtocol = GenreServiceProtocol & TrackServiceProtocol & PlaylistServiceProtocol

typealias ProfileScreenServiceProtocol = PlaylistServiceProtocol & ProfileServiceProtocol

typealias TrackScreenServiceProtocol = TrackServiceProtocol & AlbumServiceProtocol & ArtistServiceProtocol

typealias FullNetworkServiceProtocol =
    AuthServiceProtocol &
    UserServiceProtocol &
    TrackServiceProtocol &
    MyTracksServiceProtocol &
    ArtistServiceProtocol &
    LicenseServiceProtocol &
    AlbumServiceProtocol &
    MyAlbumsServiceProtocol &
    PlaylistServiceProtocol &
    GenreServiceProtocol &
    SearchServiceProtocol &
    ImageServiceProtocol


// MARK: - extension with default value
extension MyAlbumsServiceProtocol {
    func patchAlbumBySlugMy(
        slug: String,
        title: String? = nil,
        description: String? = nil,
        releaseDate: String? = nil,
        isPrivate: Bool? = nil,
        imageData: Data? = nil
    ) async throws -> Album {

        return try await patchAlbumBySlugMy(
            slug: slug,
            title: title,
            description: description,
            releaseDate: releaseDate,
            isPrivate: isPrivate,
            imageData: imageData
        )
    }
}
  
