//
//  NetworkManager+Artist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation
extension NetworkManager: ArtistServiceProtocol {
    func postFollowArtist(userId: String) async throws {
        print("userid: \(userId)")
        let url = UserEndpoint.follow(userId).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
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
                    print("❌ postFollowArtist - Response: \(responseString)")
                }
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postFollowArtist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postFollowArtist - Response: \(responseString)")
                }
                throw FavoriteError.invalidResponse
            }
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postFollowArtist - Network error: \(error)")
            
            throw error
        }
    }
    
    func postUnfollowArtist(userId: String) async throws {
        let url = UserEndpoint.unfollow(userId).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
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
                    print("❌ postUnfollowArtist - Response: \(responseString)")
                }
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postUnfollowArtist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postUnfollowArtist - Response: \(responseString)")
                }
                throw FavoriteError.invalidResponse
            }
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postUnfollowArtist - Network error: \(error)")
            throw error
        }
    }

    func getArtistsBySlug(slug: String) async throws -> Artist {
        let url = ArtistEndpoint.bySlug(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getArtistsBySlug - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getArtistsBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistsBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(Artist.self, from: data)
            } catch {
                print("❌ getArtistsBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistsBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getArtistsBySlug - Network error: \(error)")
            throw error
        }
    }

    func getArtists() async throws -> [Artist] {
        let url = ArtistEndpoint.list.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getArtists - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getArtists - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtists - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(ArtistResponse.self, from: data).results
            } catch {
                print("❌ getArtists - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtists - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getArtists - Network error: \(error)")
            throw error
        }
    }
    
    func getArtistsFavorite() async throws -> [FavoriteArtistItem] {
        let url = ArtistEndpoint.favorite.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getArtistsFavorite - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getArtistsFavorite - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistsFavorite - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(ArtistFavoriteResponse.self, from: data).results
            } catch {
                print("❌ getArtistsFavorite - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getArtistsFavorite - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getArtistsFavorite - Network error: \(error)")
            throw error
        }
    }
    
    func postAddFavoriteArtist(slug: String) async throws {
        let url = ArtistEndpoint.addFavorite(slug).url
        
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
        let url = ArtistEndpoint.removeFavorite(slug).url
        
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
        let url = ArtistEndpoint.me.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getArtistMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
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
        let url = ArtistEndpoint.me.url
        
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
