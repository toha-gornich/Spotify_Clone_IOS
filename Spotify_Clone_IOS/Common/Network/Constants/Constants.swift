//
//  Constants.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import Foundation


struct Constants {

    struct API{
        static let baseURL = "http://192.168.0.159:8080/api/v1/"
        
        static let createTokenURL = baseURL + "auth/jwt/create/"
        static let verifyTokenURL = baseURL + "auth/jwt/verify/"
        static let activationEmailURL = baseURL + "auth/users/activation/"
        static let regUserURL = baseURL + "auth/users/"
        static let userMeURL = baseURL + "auth/users/me/"
        static let profilesMyURL = baseURL + "users/profiles/my/"
        static let userURL = baseURL + "users/"
        
        
        static let tracksURL = baseURL + "tracks/"
        static let tracksLikedURL = baseURL + "tracks/like/"
        static let tracksCreateMyURL = baseURL + "tracks/my/"
        static let tracksMyURL = baseURL + "tracks/my/"
        static let trackBySlugURL = baseURL + "tracks/"
        static let tracksBySlugGenreURL = baseURL + "tracks/?genre__slug="
        static let tracksBySlugArtistURL = baseURL + "tracks/?artist__slug="
        static let tracksBySlugAlbumURL = baseURL + "tracks/?album__slug="
        static let searchTracksURL = baseURL + "tracks/?search="
        
        static let artistsURL = baseURL + "artists/"
        static let artistsFavoriteURL = baseURL + "artists/favorite/"
        static let artistMeURL = baseURL + "artists/me/"
        static let artistMeLicensesURL = baseURL + "artists/me/license/"
        static let searchArtistsURL = baseURL + "artists/?search="
        
        static let albumsURL = baseURL + "albums/"
        static let albumsFavoriteURL = baseURL + "albums/favorite/"
        static let albumsMyURL = baseURL + "albums/my/"
        static let albumsBySlugURL = baseURL + "albums/"
        static let albumsBySlugArtistURL = baseURL + "albums/?album__slug="
        static let searchAlbumsURL = baseURL + "albums/?search="
        
        static let playlistsURL = baseURL + "playlists/"
        static let playlistsFavoriteURL = baseURL + "playlists/favorite/"
        static let playlistsByGenreURL = baseURL + "playlists/?genre__slug="
        static let playlistsByIdUserURL = baseURL + "playlists/?user__id="
        static let playlistBySlugURL = baseURL + "playlists/"
        static let searchPlaylistsURL = baseURL + "playlists/?search="
        
        static let genresURL = baseURL + "others/genres/"
        static let genresBySlugURL = baseURL + "others/genres/"
        
        static let searchProfilesURL = baseURL + "users/profiles/?search="
        
    }

}
