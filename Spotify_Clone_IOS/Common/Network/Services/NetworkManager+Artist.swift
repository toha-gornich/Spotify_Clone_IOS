//
//  NetworkManager+Artist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation
extension NetworkManager: ArtistServiceProtocol {
    
    func postFollowArtist(userId: String) async throws {
        let url = UserEndpoint.follow(userId).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FavoriteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299: return
        case 400, 409:
            print("ℹ️ postFollowArtist - Already following user: \(userId)")
            throw FavoriteError.alreadyLiked
        default:
            print("❌ postFollowArtist - HTTP error \(httpResponse.statusCode)")
            throw FavoriteError.invalidResponse
        }
    }
    
    func postUnfollowArtist(userId: String) async throws {
        let url = UserEndpoint.unfollow(userId).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FavoriteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299: return
        case 400, 409:
            print("ℹ️ postUnfollowArtist - Not following user: \(userId)")
            throw FavoriteError.alreadyLiked
        default:
            print("❌ postUnfollowArtist - HTTP error \(httpResponse.statusCode)")
            throw FavoriteError.invalidResponse
        }
    }
    
    func getArtistsBySlug(slug: String) async throws -> Artist {
        let url = ArtistEndpoint.bySlug(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Artist.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
    
    func getArtists() async throws -> [Artist] {
        let url = ArtistEndpoint.list.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(ArtistResponse.self, from: data).results
        } catch {
            throw APError.invalidData
        }
    }
    
    func getArtistsFavorite() async throws -> [FavoriteArtistItem] {
        let url = ArtistEndpoint.favorite.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(ArtistFavoriteResponse.self, from: data).results
        } catch {
            throw APError.invalidData
        }
    }
    
    func postAddFavoriteArtist(slug: String) async throws {
        let url = ArtistEndpoint.addFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FavoriteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299: return
        case 400, 409: throw FavoriteError.alreadyLiked
        default: throw FavoriteError.invalidResponse
        }
    }
    
    func deleteArtistFavorite(slug: String) async throws {
        let url = ArtistEndpoint.removeFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
    }
    
    func getArtistMe() async throws -> Artist {
        let url = ArtistEndpoint.me.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Artist.self, from: data)
        } catch {
            throw APError.invalidData
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
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Artist.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
}
