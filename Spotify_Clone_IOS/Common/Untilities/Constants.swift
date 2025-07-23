//
//  Constants.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import Foundation


struct Constants {

    struct API{
        static let baseURL = "http://192.168.0.110:8080/api/v1/"
        
        static let tracksURL = baseURL + "tracks/"
        static let trackBySlugURL = baseURL + "tracks/"
        static let tracksBySlugGenreURL = baseURL + "tracks/?genre__slug="
        static let tracksBySlugArtistURL = baseURL + "tracks/?artist__slug="
        static let tracksBySlugAlbumURL = baseURL + "tracks/?album__slug="
        
        static let artistsURL = baseURL + "artists/"
        
        static let albumsURL = baseURL + "albums/"
        static let albumsBySlugURL = baseURL + "albums/"
        static let albumsBySlugArtistURL = baseURL + "albums/?album__slug="
        
        static let playlistsURL = baseURL + "playlists/"
        static let playlistBySlugURL = baseURL + "playlists/"
        
        static let genresURL = baseURL + "others/genres/"
    }

}
