//
//  Constants.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import Foundation


struct Constants {

    struct API{
//        static let baseURL = "http://192.168.0.159:8080/api/v1/"
        static let baseURL = "https://placentary-entirely-dulcie.ngrok-free.dev/api/v1/"
        
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
        static let playlistsMyURL = baseURL + "playlists/my/"
        static let myPlaylistCreateURL = baseURL + "playlists/my/"
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

// MARK: - Configuration
struct APIConfiguration {
    static var shared = APIConfiguration()
    
    lazy var environment: AppEnvironment = {
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return .production
        }
        
        if env == "DEV" {
            return .development
        }
        
        return .production
    }()
}

// MARK: - App Environment
enum AppEnvironment: String {
    case development
    case production
    
    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://placentary-entirely-dulcie.ngrok-free.dev/api/v1/")!
        case .production:
            return URL(string: "https://placentary-entirely-dulcie.ngrok-free.dev/api/v1/")!
        }
    }
}

// MARK: - Album Endpoints
enum AlbumEndpoint {
    case list
    case favorite
    case my
    case bySlug(String)
    case byArtist(String)
    case search(String)
    
    var path: String {
        switch self {
        case .list:
            return "albums/"
        case .favorite:
            return "albums/favorite/"
        case .my:
            return "albums/my/"
        case .bySlug(let slug):
            return "albums/\(slug)/"
        case .byArtist(let slug):
            return "albums/?album__slug=\(slug)"
        case .search(let query):
            return "albums/?search=\(query)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Artist Endpoints
enum ArtistEndpoint {
    case list
    case favorite
    case me
    case licenses
    case search(String)
    
    var path: String {
        switch self {
        case .list:
            return "artists/"
        case .favorite:
            return "artists/favorite/"
        case .me:
            return "artists/me/"
        case .licenses:
            return "artists/me/license/"
        case .search(let query):
            return "artists/?search=\(query)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Auth Endpoints
enum AuthEndpoint {
    case createToken
    case verifyToken
    case activationEmail
    case registerUser
    case userMe
    case profilesMy
    case user
    
    var path: String {
        switch self {
        case .createToken:
            return "auth/jwt/create/"
        case .verifyToken:
            return "auth/jwt/verify/"
        case .activationEmail:
            return "auth/users/activation/"
        case .registerUser:
            return "auth/users/"
        case .userMe:
            return "auth/users/me/"
        case .profilesMy:
            return "users/profiles/my/"
        case .user:
            return "users/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Genre Endpoints
enum GenreEndpoint {
    case list
    case bySlug(String)
    
    var path: String {
        switch self {
        case .list:
            return "others/genres/"
        case .bySlug(let slug):
            return "others/genres/\(slug)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Image Endpoints (якщо є окремі ендпоінти для зображень)
enum ImageEndpoint {
    case upload
    case getByID(String)
    
    var path: String {
        switch self {
        case .upload:
            return "images/upload/"
        case .getByID(let id):
            return "images/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - License Endpoints
enum LicenseEndpoint {
    case list
    case myLicenses
    case byID(String)
    
    var path: String {
        switch self {
        case .list:
            return "licenses/"
        case .myLicenses:
            return "artists/me/license/"
        case .byID(let id):
            return "licenses/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - MyAlbums Endpoints
enum MyAlbumEndpoint {
    case list
    case create
    case byID(String)
    case update(String)
    case delete(String)
    
    var path: String {
        switch self {
        case .list, .create:
            return "albums/my/"
        case .byID(let id), .update(let id), .delete(let id):
            return "albums/my/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - MyTracks Endpoints
enum MyTrackEndpoint {
    case list
    case create
    case byID(String)
    case update(String)
    case delete(String)
    
    var path: String {
        switch self {
        case .list, .create:
            return "tracks/my/"
        case .byID(let id), .update(let id), .delete(let id):
            return "tracks/my/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Playlist Endpoints
enum PlaylistEndpoint {
    case list
    case my
    case create
    case favorite
    case byGenre(String)
    case byUser(Int)
    case bySlug(String)
    case search(String)
    case update(String)
    case delete(String)
    
    var path: String {
        switch self {
        case .list:
            return "playlists/"
        case .my, .create:
            return "playlists/my/"
        case .favorite:
            return "playlists/favorite/"
        case .byGenre(let slug):
            return "playlists/?genre__slug=\(slug)"
        case .byUser(let id):
            return "playlists/?user__id=\(id)"
        case .bySlug(let slug):
            return "playlists/\(slug)/"
        case .search(let query):
            return "playlists/?search=\(query)"
        case .update(let id), .delete(let id):
            return "playlists/\(id)/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Search Endpoints
enum SearchEndpoint {
    case tracks(String)
    case artists(String)
    case albums(String)
    case playlists(String)
    case profiles(String)
    case all(String)
    
    var path: String {
        switch self {
        case .tracks(let query):
            return "tracks/?search=\(query)"
        case .artists(let query):
            return "artists/?search=\(query)"
        case .albums(let query):
            return "albums/?search=\(query)"
        case .playlists(let query):
            return "playlists/?search=\(query)"
        case .profiles(let query):
            return "users/profiles/?search=\(query)"
        case .all(let query):
            return "search/?q=\(query)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - Track Endpoints
enum TrackEndpoint {
    case list
    case liked
    case my
    case createMy
    case bySlug(String)
    case byGenre(String)
    case byArtist(String)
    case byAlbum(String)
    case search(String)
    case like(String)
    case unlike(String)
    
    var path: String {
        switch self {
        case .list:
            return "tracks/"
        case .liked:
            return "tracks/like/"
        case .my, .createMy:
            return "tracks/my/"
        case .bySlug(let slug):
            return "tracks/\(slug)/"
        case .byGenre(let slug):
            return "tracks/?genre__slug=\(slug)"
        case .byArtist(let slug):
            return "tracks/?artist__slug=\(slug)"
        case .byAlbum(let slug):
            return "tracks/?album__slug=\(slug)"
        case .search(let query):
            return "tracks/?search=\(query)"
        case .like(let id), .unlike(let id):
            return "tracks/\(id)/like/"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}

// MARK: - User Endpoints
enum UserEndpoint {
    case me
    case profileMe
    case byID(String)
    case updateProfile
    case search(String)
    
    var path: String {
        switch self {
        case .me:
            return "auth/users/me/"
        case .profileMe, .updateProfile:
            return "users/profiles/my/"
        case .byID(let id):
            return "users/\(id)/"
        case .search(let query):
            return "users/profiles/?search=\(query)"
        }
    }
    
    var url: URL {
        return APIConfiguration.shared.environment.baseURL.appendingPathComponent(path)
    }
}
