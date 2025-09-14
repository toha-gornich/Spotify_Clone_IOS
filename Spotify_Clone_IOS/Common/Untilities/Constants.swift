//
//  Constants.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import Foundation


struct Constants {

    struct API{
        static let baseURL = "http://192.168.0.160:8080/api/v1/"
        
        static let createTokenURL = baseURL + "auth/jwt/create/"
        static let verifyTokenURL = baseURL + "auth/jwt/verify/"
        static let activationEmailURL = baseURL + "auth/users/activation/"
        static let regUserURL = baseURL + "auth/users/"
        
        static let tracksURL = baseURL + "tracks/"
        static let trackBySlugURL = baseURL + "tracks/"
        static let tracksBySlugGenreURL = baseURL + "tracks/?genre__slug="
        static let tracksBySlugArtistURL = baseURL + "tracks/?artist__slug="
        static let tracksBySlugAlbumURL = baseURL + "tracks/?album__slug="
        static let searchTracksURL = baseURL + "tracks/?search="
        
        static let artistsURL = baseURL + "artists/"
        static let searchArtistsURL = baseURL + "artists/?search="
        
        static let albumsURL = baseURL + "albums/"
        static let albumsBySlugURL = baseURL + "albums/"
        static let albumsBySlugArtistURL = baseURL + "albums/?album__slug="
        static let searchAlbumsURL = baseURL + "albums/?search="
        
        static let playlistsURL = baseURL + "playlists/"
        static let playlistsByGenreURL = baseURL + "playlists/?genre__slug="
        static let playlistBySlugURL = baseURL + "playlists/"
        static let searchPlaylistsURL = baseURL + "playlists/?search="
        
        static let genresURL = baseURL + "others/genres/"
        static let genresBySlugURL = baseURL + "others/genres/"
        
        static let searchProfilesURL = baseURL + "users/profiles/?search="
        
        
        
        
    }

}
