//
//  NetworkManager+Album.swift.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: AlbumServiceProtocol {

    func getAlbumsFavorite() async throws -> [FavoriteAlbumItem] {
        let url = AlbumEndpoint.favorite.url
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getAlbumsFavorite - Invalid response type")
            throw APError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getAlbumsFavorite - HTTP error \(httpResponse.statusCode)")
            print("❌ getAlbumsFavorite - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(AlbumFavoriteResponse.self, from: data).results
        } catch {
            print("❌ getAlbumsFavorite - Failed to decode: \(error)")
            print("❌ getAlbumsFavorite - Raw response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidData
        }
    }

    func postAddFavoriteAlbum(slug: String) async throws {
        let url = AlbumEndpoint.addFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postAddFavoriteAlbum - Invalid response type")
            throw FavoriteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400, 409:
            print("ℹ️ postAddFavoriteAlbum - Already in favorites: \(slug)")
            throw FavoriteError.alreadyLiked
        default:
            print("❌ postAddFavoriteAlbum - HTTP error \(httpResponse.statusCode)")
            print("❌ postAddFavoriteAlbum - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw FavoriteError.invalidResponse
        }
    }

    func deleteAlbumsFavorite(slug: String) async throws {
        let url = AlbumEndpoint.removeFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ deleteAlbumsFavorite - Invalid response type")
            throw APError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ deleteAlbumsFavorite - HTTP error \(httpResponse.statusCode)")
            print("❌ deleteAlbumsFavorite - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidResponse
        }
    }

    func getAlbums() async throws -> [Album] {
        let url = AlbumEndpoint.list.url
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getAlbums - Invalid response type")
            throw APError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getAlbums - HTTP error \(httpResponse.statusCode)")
            print("❌ getAlbums - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ getAlbums - Failed to decode: \(error)")
            print("❌ getAlbums - Raw response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidData
        }
    }

    func getAlbumBySlug(slug: String) async throws -> Album {
        let url = AlbumEndpoint.bySlug(slug).url
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getAlbumBySlug - Invalid response type")
            throw APError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getAlbumBySlug - HTTP error \(httpResponse.statusCode)")
            print("❌ getAlbumBySlug - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Album.self, from: data)
        } catch {
            print("❌ getAlbumBySlug - Failed to decode: \(error)")
            print("❌ getAlbumBySlug - Raw response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidData
        }
    }

    func getAlbumsBySlugArtist(slug: String) async throws -> [Album] {
        let url = AlbumEndpoint.byArtist(slug).url
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getAlbumsBySlugArtist - Invalid response type")
            throw APError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getAlbumsBySlugArtist - HTTP error \(httpResponse.statusCode)")
            print("❌ getAlbumsBySlugArtist - Response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(AlbumResponse.self, from: data).results
        } catch {
            print("❌ getAlbumsBySlugArtist - Failed to decode: \(error)")
            print("❌ getAlbumsBySlugArtist - Raw response: \(String(data: data, encoding: .utf8) ?? "")")
            throw APError.invalidData
        }
    }
}
