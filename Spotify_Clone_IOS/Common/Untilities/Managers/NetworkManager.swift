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
        guard let url = URL(string: Constants.API.regUserURL) else {
            print("❌ postRegUser - Invalid URL: \(Constants.API.regUserURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(regUser)
        } catch {
            print("❌ postRegUser - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postRegUser - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postRegUser - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postRegUser - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(RegUserResponse.self, from: data)
            } catch {
                print("❌ postRegUser - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postRegUser - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postRegUser - Network error: \(error)")
            throw error
        }
    }

    func postLogin(loginRequest: LoginRequest) async throws -> LoginResponse {
        guard let url = URL(string: Constants.API.createTokenURL) else {
            print("❌ postLogin - Invalid URL: \(Constants.API.createTokenURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(loginRequest)
        } catch {
            print("❌ postLogin - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postLogin - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postLogin - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postLogin - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(LoginResponse.self, from: data)
            } catch {
                print("❌ postLogin - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postLogin - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postLogin - Network error: \(error)")
            throw error
        }
    }

    func postVerifyToken(tokenVerifyRequest: TokenVerifyRequest) async throws {
        guard let url = URL(string: Constants.API.verifyTokenURL) else {
            print("❌ postVerifyToken - Invalid URL: \(Constants.API.verifyTokenURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(tokenVerifyRequest)
        } catch {
            print("❌ postVerifyToken - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postVerifyToken - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postVerifyToken - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postVerifyToken - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ postVerifyToken - Network error: \(error)")
            throw error
        }
    }

    func postActivateAccount(activationRequest: AccountActivationRequest) async throws {
        guard let url = URL(string: Constants.API.activationEmailURL) else {
            print("❌ postActivateAccount - Invalid URL: \(Constants.API.activationEmailURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(activationRequest)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postActivateAccount - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postActivateAccount - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postActivateAccount - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ postActivateAccount - Error: \(error)")
            throw error
        }
    }

    func getUserMe() async throws -> UserMy {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ getUserMe - Invalid URL: \(Constants.API.userMeURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(UserMy.self, from: data)
            } catch {
                print("❌ getUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getUserMe - Network error: \(error)")
            throw error
        }
    }

    func putUserMe(user: UpdateUserMe, imageData: Data? = nil) async throws -> UserMy {
        guard let url = URL(string: Constants.API.profilesMyURL) else {
            print("❌ putUserMe - Invalid URL: \(Constants.API.profilesMyURL)")
            throw APError.invalidURL
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func addFormField(name: String, value: String) {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8) { body.append(data) }
            if let data = "\(value)\r\n".data(using: .utf8) { body.append(data) }
        }
        
        user.displayName.map { addFormField(name: "display_name", value: $0) }
        user.gender.map { addFormField(name: "gender", value: $0) }
        user.country.map { addFormField(name: "country", value: $0) }

        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"profile.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ putUserMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ putUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(UserMy.self, from: data)
                return result
            } catch {
                print("❌ putUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ putUserMe - Network error: \(error)")
            throw error
        }
    }

    func deleteUserMe(password: String) async throws {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ deleteUserMe - Invalid URL: \(Constants.API.userMeURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deleteRequest = ["current_password": password]
        
        do {
            let jsonData = try JSONEncoder().encode(deleteRequest)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteUserMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteUserMe - Network error: \(error)")
            throw error
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
