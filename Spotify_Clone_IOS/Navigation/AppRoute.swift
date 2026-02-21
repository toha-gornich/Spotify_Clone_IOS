//
//  HomeRoute.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 20.02.2026.
//

import Foundation


enum AppRoute: Hashable{
    case track(slugTrack: String)
    case artist(slugArtist: String)
    case album(slugAlbum: String)
    case playlist(slugPlaylist: String)
    case myPlaylist(slugPlaylist: String)
    case genreDetails(slugGenre: String)
    case search(searchText: String)
    case profile(profileId: String)
    
}
