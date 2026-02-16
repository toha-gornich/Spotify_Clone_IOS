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
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTracks - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTracks - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracks - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ getTracks - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracks - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracks - Network error: \(error)")
            throw error
        }
    }

    func getTrackBySlug(slug: String) async throws -> TrackDetail {
        let url = TrackEndpoint.bySlug(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTrackBySlug - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTrackBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTrackBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TrackDetail.self, from: data)
            } catch {
                print("❌ getTrackBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTrackBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTrackBySlug - Network error: \(error)")
            throw error
        }
    }
    
    func getTracksBySlugArtist(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byArtist(slug).url
        print(url.path())
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTracksBySlugArtist - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTracksBySlugArtist - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugArtist - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ getTracksBySlugArtist - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugArtist - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracksBySlugArtist - Network error: \(error)")
            throw error
        }
    }
    
    func getTracksBySlugGenre(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byGenre(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTracksBySlugGenre - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTracksBySlugGenre - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugGenre - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ getTracksBySlugGenre - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugGenre - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracksBySlugGenre - Network error: \(error)")
            throw error
        }
    }
    
    func getTracksBySlugAlbum(slug: String) async throws -> [Track] {
        let url = TrackEndpoint.byAlbum(slug).url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTracksBySlugAlbum - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTracksBySlugAlbum - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugAlbum - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ getTracksBySlugAlbum - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksBySlugAlbum - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracksBySlugAlbum - Network error: \(error)")
            throw error
        }
    }
    
    func getTracksLiked() async throws -> [Track] {
        let url = TrackEndpoint.liked.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getTracksLiked - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getTracksLiked - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksLiked - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksResponse.self, from: data).results
            } catch {
                print("❌ getTracksLiked - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTracksLiked - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTracksLiked - Network error: \(error)")
            throw error
        }
    }
    
    func postLikeTrack(slug: String) async throws {
        let url = TrackEndpoint.like(slug).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
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
                if let responseString = String(data: data, encoding: .utf8) {}
                throw FavoriteError.invalidResponse
            }
            
        } catch let error as FavoriteError {
            throw error
        } catch {
            print("❌ postLikeTrack - Network error: \(error)")
            throw error
        }
    }
    
    func deleteTrackLike(slug: String) async throws {
        let url = TrackEndpoint.unlike(slug).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteTrackLike - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteTrackLike - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteTrackLike - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteTrackLike - Network error: \(error)")
            throw error
        }
    }
}
