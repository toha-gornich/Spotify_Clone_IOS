//
//  NetworkManager+MyTracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: TrackServiceProtocol {
    
    func getTracks() async throws -> [Track] {
        let url = TrackEndpoint.tracks.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTracks - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTracks - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ getTracks - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func getTrackBySlug(slug: String) async throws -> TrackDetail {
        let url = TrackEndpoint.bySlug(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTrackBySlug - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTrackBySlug - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TrackDetail.self, from: data)
        } catch {
            print("❌ getTrackBySlug - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getTracksBySlugArtist(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byArtist(slug).url
        print(url.path())
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTracksBySlugArtist - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTracksBySlugArtist - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ getTracksBySlugArtist - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getTracksBySlugGenre(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byGenre(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTracksBySlugGenre - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTracksBySlugGenre - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ getTracksBySlugGenre - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getTracksBySlugAlbum(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byAlbum(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTracksBySlugAlbum - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTracksBySlugAlbum - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ getTracksBySlugAlbum - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getTracksLiked() async throws -> [Track] {
        let url = TrackEndpoint.liked.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getTracksLiked - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getTracksLiked - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ getTracksLiked - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func postLikeTrack(slug: String) async throws {
        let url = TrackEndpoint.like(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postLikeTrack - Invalid response type")
            throw APError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400, 409:
            print("ℹ️ postLikeTrack - Track already liked: \(slug)")
            throw FavoriteError.alreadyLiked
        default:
            print("❌ postLikeTrack - HTTP error \(httpResponse.statusCode)")
            throw FavoriteError.invalidResponse
        }
    }
    
    func deleteTrackLike(slug: String) async throws {
        let url = TrackEndpoint.unlike(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ deleteTrackLike - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ deleteTrackLike - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
    }
}
