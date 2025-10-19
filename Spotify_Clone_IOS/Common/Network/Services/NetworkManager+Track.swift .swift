//
//  NetworkManager+MyTracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: TrackServiceProtocol {
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
    
    func getTracksLiked() async throws -> [Track] {
        guard let url = URL(string: Constants.API.albumsFavoriteURL) else {
            print("❌ [getTracksLiked] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getTracksLiked] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TracksResponse.self, from: data).results
        } catch {
            print("❌ [getTracksLiked] JSON decoding failed: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [getTracksLiked] Raw JSON: \(jsonString)")
            }
            throw APError.invalidData
        }
    }
    
    func postLikeTrack(slug: String) async throws {
        let urlString = "\(Constants.API.tracksURL)" + "\(slug)/like/"
        
        guard let url = URL(string: urlString) else {
            print("❌ postLikeTrack - Invalid URL: \(urlString)")
            throw FavoriteError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postLikeTrack - Invalid response type")
                throw APError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                return
                
            case 400, 409:
                print("ℹ️ postLikeTrack - Track already liked: \(slug)")
                throw FavoriteError.alreadyLiked
                
            default:
                print("❌ postLikeTrack - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postLikeTrack - Response: \(responseString)")
                }
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
        guard let url = URL(string: Constants.API.tracksURL + "\(slug)/like/") else {
            print("❌ deleteTrackLike - Invalid URL: \(Constants.API.tracksURL + "\(slug)/like/")")
            throw APError.invalidURL
        }
        
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
                print("❌ deleteAlbumdeleteTrackLikesFavorite - HTTP error \(httpResponse.statusCode)")
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
