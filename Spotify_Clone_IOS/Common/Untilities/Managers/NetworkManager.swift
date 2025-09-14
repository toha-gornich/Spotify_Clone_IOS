//
//  NetworkManager.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 31.05.2025.
//

import SwiftUI



final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
        
    private init() {}
  
    
    func postRegUser(regUser: RegUser) async throws -> RegUserResponse {
        print("postRegUser")
        guard let url = URL(string: Constants.API.regUserURL) else {
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(regUser)
        } catch {
            throw APError.invalidData
        }
        
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RegUserResponse.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
    
    func postLogin(loginRequest: LoginRequest) async throws -> LoginResponse {
        print("postLogin")
        guard let url = URL(string: Constants.API.createTokenURL) else {
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(loginRequest)
        } catch {
            throw APError.invalidData
        }
        
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(LoginResponse.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
    
    func postVerifyToken(tokenVerifyRequest: TokenVerifyRequest) async throws {
        print("postVerifyToken")
        guard let url = URL(string: Constants.API.verifyTokenURL) else {
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(tokenVerifyRequest)
        } catch {
            throw APError.invalidData
        }
        
        
        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
    }
    
    func postActivateAccount(activationRequest: AccountActivationRequest) async throws {
        print("postActivateAccount - Starting")
        
        guard let url = URL(string: Constants.API.activationEmailURL) else {
            print("postActivateAccount - Invalid URL")
            throw APError.invalidURL
        }
        
        print("postActivateAccount - URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(activationRequest)
        request.httpBody = jsonData
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("postActivateAccount - Data: \(jsonString)")
        }
        
        print("postActivateAccount - Sending request")
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            print("postActivateAccount - Invalid response: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw APError.invalidResponse
        }
        
    }
    func getTracks() async throws ->[Track] {
        print("getTracks")
        guard let url = URL(string: Constants.API.tracksURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(TracksResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    
    func getTrackBySlug(slug:String) async throws -> TrackDetail {
        print("getTrackBySlug")
        guard let url = URL(string: Constants.API.trackBySlugURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(TrackDetail.self, from: data)
        } catch{
            throw APError.invalidData
        }
         
    }

    
    
    func getTracksBySlugArtist(slug: String) async throws -> [Track] {
        print("getTracksBySlugArtist")
       let fullURL = Constants.API.tracksBySlugArtistURL + "\(slug)"
       
       guard let url = URL(string: fullURL) else {
           throw APError.invalidURL
       }
       
       do {
           let (data, _) = try await URLSession.shared.data(from: url)
           let decoder = JSONDecoder()
           let tracks = try decoder.decode(TracksResponse.self, from: data).results
           return tracks
       } catch {
           throw APError.invalidData
       }
    }
    
    func getTracksBySlugGenre(slug: String) async throws -> [Track] {
        print("getTracksBySlugGenre")
       let fullURL = Constants.API.tracksBySlugGenreURL + "\(slug)"
       
       guard let url = URL(string: fullURL) else {
           throw APError.invalidURL
       }
       
       do {
           let (data, _) = try await URLSession.shared.data(from: url)
           let decoder = JSONDecoder()
           let tracks = try decoder.decode(TracksResponse.self, from: data).results
           return tracks
       } catch {
           throw APError.invalidData
       }
    }
    
    
    func getTracksBySlugAlbum(slug: String) async throws -> [Track] {
        print("getTracksBySlugAlbum")
        
        guard let url = URL(string: Constants.API.tracksBySlugAlbumURL + "\(slug)") else {
            throw APError.invalidURL
        }
         
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(TracksResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    
    func getArtistsBySlug(slug:String) async throws -> Artist {
        print("getArtistsBySlug")
        guard let url = URL(string: Constants.API.artistsURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Artist.self, from: data)
        } catch{
            throw APError.invalidData
        }
         
    }
    
    func getArtists() async throws ->[Artist] {
        print("getArtists")
        guard let url = URL(string: Constants.API.artistsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(ArtistResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    
    func getAlbums() async throws ->[Album] {
        print("getAlbums")
        guard let url = URL(string: Constants.API.albumsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func getAlbumBySlug(slug: String) async throws -> Album {
        print("getAlbumBySlug")
        guard let url = URL(string: Constants.API.albumsBySlugURL + "\(slug)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Album.self, from: data)
        } catch{
            throw APError.invalidData
        }
    }

    
    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        print("getAlbumsBySlugArtist")
        guard let url = URL(string: Constants.API.albumsBySlugArtistURL + "\(slug)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }

    
    func getPlaylists() async throws ->[Playlist] {
        print("getPlaylists")
        guard let url = URL(string: Constants.API.playlistsURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            
            throw APError.invalidData
        }
        
        
    }
    
    func getPlaylistsBySlug(slug:String) async throws -> PlaylistDetail {
        print("getPlaylistsBySlug")
        guard let url = URL(string: Constants.API.playlistBySlugURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistDetail.self, from: data)
        } catch{
            throw APError.invalidData
        }
         
    }
    
    func getPlaylistsBySlugGenre(slug:String) async throws ->[Playlist] {
        print("getPlaylistsBySlugGenre")
        guard let url = URL(string: Constants.API.playlistsByGenreURL + slug) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            
            throw APError.invalidData
        }
         
    }
    
    
    func getGenres() async throws ->[Genre] {
        print("getGenres")
        guard let url = URL(string: Constants.API.genresURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(GenresResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
        
        
    }
    
    func getGenreBySlug(slug:String) async throws -> Genre {
        print("getGenreBySlug")
        guard let url = URL(string: Constants.API.genresBySlugURL + "\(slug)/") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Genre.self, from: data)
        } catch{
            throw APError.invalidData
        }
         
    }
    

    
    func searchTracks(searchText:String) async throws -> [Track] {
        print("searchTracks")
        guard let url = URL(string: Constants.API.searchTracksURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(TracksResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func searchArtists(searchText:String) async throws -> [Artist] {
        print("searchArtists")
        guard let url = URL(string: Constants.API.searchArtistsURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(ArtistResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func searchAlbums(searchText:String) async throws -> [Album] {
        print("searchAlbums")
        guard let url = URL(string: Constants.API.searchAlbumsURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func searchPlaylists(searchText:String) async throws -> [Playlist] {
        print("searchPlaylists")
        guard let url = URL(string: Constants.API.searchPlaylistsURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func searchProfiles(searchText:String) async throws -> [User] {
        print("searchProfiles")
        guard let url = URL(string: Constants.API.searchProfilesURL + "\(searchText)") else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(UserResponse.self, from: data).results
        } catch{
            throw APError.invalidData
        }
    }
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){ data, response, error in
            
            guard let data, let image = UIImage(data:data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()

    }
    
}
