//
//  NetworkManager+Artist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: ArtistServiceProtocol {
    func postFollowArtist(userId: String) async throws {
        print("userid" + userId)
        let urlString = "\(Constants.API.userURL)\(userId)/follow/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postFollowArtist - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postFollowArtist - Invalid response type")
            throw FavoriteError.invalidResponse
        }
        
        print("📡 postFollowArtist - HTTP Status Code: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200...299:
            
            return
            
        case 400, 409:
            print("ℹ️ postFollowArtist - Already following user: \(userId)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response: \(responseString)")
            }
            throw FavoriteError.alreadyLiked
            
        default:
            print("❌ postFollowArtist - HTTP error \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response: \(responseString)")
            }
            throw FavoriteError.invalidResponse
        }
    }
    
    func postUnfollowArtist(userId: String) async throws {
        let urlString = "\(Constants.API.userURL)\(userId)/unfollow/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postUnfollowArtist - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postUnfollowArtist - Invalid response type")
            throw FavoriteError.invalidResponse
        }
        
        print("📡 postUnfollowArtist - HTTP Status Code: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200...299:
            
            return
            
        case 400, 409:
            print("ℹ️ postUnfollowArtist - Not following user: \(userId)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response: \(responseString)")
            }
            throw FavoriteError.alreadyLiked
            
        default:
            print("❌ postUnfollowArtist - HTTP error \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response: \(responseString)")
            }
            throw FavoriteError.invalidResponse
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
    
    func getArtistsFavorite() async throws -> [FavoriteArtistItem] {
        guard let url = URL(string: Constants.API.artistsFavoriteURL) else {
            print("❌ [getArtistsFavorite] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getArtistsFavorite] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()

            return try decoder.decode(ArtistFavoriteResponse.self, from: data).results
        } catch {
            print("❌ [getArtistsFavorite] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getArtistsFavorite] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }
    
    func postAddFavoriteArtist(slug: String) async throws {
        let urlString = Constants.API.artistsURL + "\(slug)/favorite/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postAddFavoriteArtist - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postAddFavoriteArtist - Invalid response type")
                throw FavoriteError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                
                return
                
            case 400, 409:
                print("ℹ️ postAddFavoriteArtist - Already in favorites: \(slug)")
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postAddFavoriteArtist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postAddFavoriteArtist - Response: \(responseString)")
                }
                throw FavoriteError.invalidResponse
            }
            
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postAddFavoriteArtist - Network error: \(error)")
            throw error
        }
    }
    
    func deleteArtistFavorite(slug: String) async throws {
        guard let url = URL(string: Constants.API.artistsURL + "\(slug)/favorite/") else {
            print("❌ deleteArtistFavorite - Invalid URL: \(Constants.API.artistsURL + "\(slug)/favorite/")")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteArtistFavorite - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteArtistFavorite - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteArtistFavorite - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteArtistFavorite - Network error: \(error)")
            throw error
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
    
    
    
    
}
