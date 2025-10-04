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
  

    // MARK: - Users auth
    
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

    func getUserMe() async throws -> UserMe {
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
                return try decoder.decode(UserMe.self, from: data)
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
    
    func getProfileMy() async throws -> UserMy {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ getUserMe - Invalid URL: \(Constants.API.profilesMyURL)")
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
    
    // MARK: - Tracks
    
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
    
    func postCreateTrack(
        title: String,
        albumId: Int,
        genreId: Int,
        licenseId: Int,
        releaseDate: String,
        isPrivate: Bool,
        imageData: Data?,
        audioData: Data?
    ) async throws -> Track {
        guard let url = URL(string: Constants.API.tracksCreateMyURL) else {
            print("❌ postCreateTrack - Invalid URL: \(Constants.API.tracksCreateMyURL)")
            throw APError.invalidURL
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func addFormField(name: String, value: String) {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8) { body.append(data) }
            if let data = "\(value)\r\n".data(using: .utf8) { body.append(data) }
        }
        
        // Додаємо текстові поля
        addFormField(name: "title", value: title)
        addFormField(name: "album", value: String(albumId))
        addFormField(name: "genre", value: String(genreId))
        addFormField(name: "license", value: String(licenseId))
        addFormField(name: "release_date", value: releaseDate)
        addFormField(name: "is_private", value: isPrivate ? "true" : "false")
        
        // Додаємо зображення (поле "image")
        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"track_image.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        // Додаємо аудіо файл (поле "file")
        if let audioData = audioData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"file\"; filename=\"track_audio.mp3\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(audioData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postCreateTrack - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postCreateTrack - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateTrack - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Track.self, from: data)
                return result
            } catch {
                print("❌ postCreateTrack - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateTrack - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postCreateTrack - Network error: \(error)")
            throw error
        }
    }
    
    func getTrackMy() async throws -> [TracksMy] {
        guard let url = URL(string: Constants.API.artistMeURL) else {
            print("❌ getArtistMe - Invalid URL: \(Constants.API.tracksMyURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getArtistMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksMyResponse.self, from: data).results
            } catch {
                print("❌ getArtistMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getArtistMe - Network error: \(error)")
            throw error
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
    
    func getTracksMy() async throws -> [TracksMy] {
        guard let url = URL(string: Constants.API.tracksMyURL) else {
            print("❌ getTracksMy - Invalid URL: \(Constants.API.tracksMyURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getTracksMy - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksMy - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksMyResponse.self, from: data).results
            } catch {
                print("❌ getTracksMy - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksMy - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracksMy - Network error: \(error)")
            throw error
        }
    }
    
    func patchTracksMy(slug: String, isPrivate: Bool, retryCount: Int = 0) async throws {
        guard let url = URL(string: Constants.API.tracksMyURL + "\(slug)/") else {
            print("❌ patchTracksMy - Invalid URL: \(Constants.API.tracksMyURL + "\(slug)/")")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["is_private": isPrivate]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ patchTracksMy - Invalid response type")
                throw APError.invalidResponse
            }
            
            if httpResponse.statusCode == 500 && retryCount < 3 {
                if let responseString = String(data: data, encoding: .utf8),
                   responseString.contains("database is locked") {
                    print("⏳ patchTracksMy - Database locked, retrying in 1 second... (attempt \(retryCount + 1)/3)")
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
                    return try await patchTracksMy(slug: slug, isPrivate: isPrivate, retryCount: retryCount + 1)
                }
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ patchTracksMy - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchTracksMy - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            
        } catch {
            print("❌ patchTracksMy - Network error: \(error)")
            throw error
        }
    }

    
    func deleteTracksMy(slug: String) async throws {
        guard let url = URL(string: Constants.API.tracksMyURL + "\(slug)/") else {
            print("❌ deleteTracksMy - Invalid URL: \(Constants.API.tracksMyURL + "\(slug)/")")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteTracksMy - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteTracksMy - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteTracksMy - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteTracksMy - Network error: \(error)")
            throw error
        }
    }
    
    // MARK: - Artists
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
    
    func getArtistMe() async throws -> Artist {
        guard let url = URL(string: Constants.API.artistMeURL) else {
            print("❌ getArtistMe - Invalid URL: \(Constants.API.profilesMyURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getArtistMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Artist.self, from: data)
            } catch {
                print("❌ getArtistMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getArtistMe - Network error: \(error)")
            throw error
        }
    }
    
    func putArtistMe(artist: UpdateArtist, imageData: Data? = nil) async throws -> Artist {
        guard let url = URL(string: Constants.API.artistMeURL) else {
            print("❌ putArtistMe - Invalid URL: \(Constants.API.profilesMyURL)")
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
        
        addFormField(name: "first_name", value: artist.firstName)
        addFormField(name: "last_name", value: artist.lastName)
        addFormField(name: "display_name", value: artist.displayName)

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
                print("❌ putArtistMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ putArtistMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putArtistMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Artist.self, from: data)
                return result
            } catch {
                print("❌ putArtistMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putArtistMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ putArtistMe - Network error: \(error)")
            throw error
        }
    }
    
    
    func getLicenses() async throws ->[License] {
        guard let url = URL(string: Constants.API.artistMeLicensesURL) else {
            print("❌ [getLicenses] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getLicenses] Response error: \(httpResponse.statusCode)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode([License].self, from: data)
        } catch{
            print("❌ [getLicenses] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    
    
    // MARK: - Albums
    func getAlbums() async throws -> [Album] {
        print("getAlbums")
        guard let url = URL(string: Constants.API.albumsURL) else {
            print("❌ [getAlbums] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbums] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ [getAlbums] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbums] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    func getAlbumsMy() async throws -> [AlbumMy] {
        print("getAlbumsMy")
        guard let url = URL(string: Constants.API.albumsMyURL) else {
            print("❌ [getAlbumsMy] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumsMy] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumMyResponse.self, from: data).results
        } catch {
            print("❌ [getAlbumsMy] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumsMy] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    func getAlbumBySlug(slug: String) async throws -> Album {
        print("getAlbumBySlug")
        guard let url = URL(string: Constants.API.albumsBySlugURL + "\(slug)") else {
            print("❌ [getAlbumBySlug] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumBySlug] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Album.self, from: data)
        } catch {
            print("❌ [getAlbumBySlug] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumBySlug] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        print("getAlbumsBySlugArtist")
        guard let url = URL(string: Constants.API.albumsBySlugArtistURL + "\(slug)") else {
            print("❌ [getAlbumsBySlugArtist] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getAlbumsBySlugArtist] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ [getAlbumsBySlugArtist] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getAlbumsBySlugArtist] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }

    // MARK: - Playlists
    
    func getPlaylists() async throws ->[Playlist] {
        guard let url = URL(string: Constants.API.playlistsURL) else {
            print("❌ [getPlaylists] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylists] Response error: \(httpResponse.statusCode)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            print("❌ [getPlaylists] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsByIdUser(idUser: Int) async throws -> [Playlist] {
        guard let url = URL(string: Constants.API.playlistsByIdUserURL + "\(idUser)") else {
            print("❌ [getPlaylistsByIdUser] Invalid URL for user ID: \(idUser)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsByIdUser] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            let playlists = try decoder.decode(PlaylistResponse.self, from: data).results
            return playlists
        } catch {
            print("❌ [getPlaylistsByIdUser] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsBySlug(slug:String) async throws -> PlaylistDetail {
        guard let url = URL(string: Constants.API.playlistBySlugURL + "\(slug)/") else {
            print("❌ [getPlaylistsBySlug] Invalid URL for slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsBySlug] Response error: \(httpResponse.statusCode) for slug: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistDetail.self, from: data)
        } catch{
            print("❌ [getPlaylistsBySlug] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }

    func getPlaylistsBySlugGenre(slug:String) async throws ->[Playlist] {
        guard let url = URL(string: Constants.API.playlistsByGenreURL + slug) else {
            print("❌ [getPlaylistsBySlugGenre] Invalid URL for genre slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylistsBySlugGenre] Response error: \(httpResponse.statusCode) for genre: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(PlaylistResponse.self, from: data).results
        } catch{
            print("❌ [getPlaylistsBySlugGenre] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }

    // MARK: - Genres

    func getGenres() async throws -> [Genre] {
        guard let url = URL(string: Constants.API.genresURL) else {
            print("❌ [getGenres] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getGenres] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase 
            return try decoder.decode(GenresResponse.self, from: data).results
        } catch {
            print("❌ [getGenres] JSON decoding failed: \(error)")
            throw APError.invalidData
        }
    }

    func getGenreBySlug(slug:String) async throws -> Genre {
        guard let url = URL(string: Constants.API.genresBySlugURL + "\(slug)/") else {
            print("❌ [getGenreBySlug] Invalid URL for slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getGenreBySlug] Response error: \(httpResponse.statusCode) for slug: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Genre.self, from: data)
        } catch{
            print("❌ [getGenreBySlug] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    

    // MARK: - Search
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
    
    // MARK: - Other
    
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
