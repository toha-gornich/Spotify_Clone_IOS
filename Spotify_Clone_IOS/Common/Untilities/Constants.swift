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
        static let tracksBySlugArtistURL = baseURL + "tracks/?artist_slug="
        static let artistsURL = baseURL + "artists/"
//        static let artistsBySlugURL = baseURL + "artists/"
        static let albumsURL = baseURL + "albums/"
        static let playlistsURL = baseURL + "playlists/"
    }

}
