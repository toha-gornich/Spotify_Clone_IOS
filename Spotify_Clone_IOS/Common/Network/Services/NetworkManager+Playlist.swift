//
//  NetworkManager+Playlist.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation
extension NetworkManager: PlaylistServiceProtocol {
    
    func postTrackToPlaylist(slug: String, trackSlug: String) async throws {
        let url = PlaylistEndpoint.addTrack(slug, trackSlug).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["track_id": trackSlug]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        var lastError: Error?
        
        for attempt in 1...3 {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ postTrackToPlaylist - Invalid response type")
                    throw APError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        if responseString.contains("database is locked") && attempt < 3 {
                            print("⚠️ postTrackToPlaylist - Database locked, retry \(attempt)/3")
                            try await Task.sleep(nanoseconds: UInt64(attempt) * 500_000_000)
                            continue
                        }
                        print("❌ postTrackToPlaylist - HTTP \(httpResponse.statusCode): \(responseString)")
                        if httpResponse.statusCode == 400 {
                            print("⚠️ postTrackToPlaylist - Track already in playlist")
                        }
                    }
                    throw APError.invalidResponse
                }
                return
            } catch {
                lastError = error
                if attempt < 3 {
                    try await Task.sleep(nanoseconds: 500_000_000)
                    continue
                }
                print("❌ postTrackToPlaylist - Network error: \(error)")
            }
        }
        throw lastError ?? APError.invalidResponse
    }
    
    func deleteTrackFromPlaylist(slug: String, trackSlug: String) async throws {
        let url = PlaylistEndpoint.deleteTrack(slug, trackSlug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var lastError: Error?
        
        for attempt in 1...3 {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APError.invalidResponse
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    return
                } else if httpResponse.statusCode == 404 {
                    if let responseString = String(data: data, encoding: .utf8),
                       (responseString.contains("Track not in playlist") || responseString.contains("not in playlist")) {
                        return
                    }
                    throw APError.invalidResponse
                } else {
                    if let responseString = String(data: data, encoding: .utf8),
                       responseString.contains("database is locked"),
                       attempt < 3 {
                        try await Task.sleep(nanoseconds: UInt64(attempt) * 500_000_000)
                        continue
                    }
                    throw APError.invalidResponse
                }
            } catch {
                lastError = error
                if attempt < 3 {
                    try await Task.sleep(nanoseconds: 500_000_000)
                    continue
                }
            }
        }
        throw lastError ?? APError.invalidResponse
    }
    
    func deletePlaylist(slug: String) async throws {
        let url = PlaylistEndpoint.delete(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var lastError: Error?
        
        for attempt in 1...3 {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ deletePlaylist - Invalid response type")
                    throw APError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        if responseString.contains("database is locked") && attempt < 3 {
                            print("⚠️ deletePlaylist - Database locked, retry \(attempt)/3")
                            try await Task.sleep(nanoseconds: UInt64(attempt) * 500_000_000)
                            continue
                        }
                        print("❌ deletePlaylist - HTTP \(httpResponse.statusCode): \(responseString)")
                    }
                    throw APError.invalidResponse
                }
                return
            } catch {
                lastError = error
                if attempt < 3 {
                    try await Task.sleep(nanoseconds: 500_000_000)
                    continue
                }
                print("❌ deletePlaylist - Network error: \(error)")
            }
        }
        throw lastError ?? APError.invalidResponse
    }
    
    func postMyPlaylist() async throws -> PlaylistDetail {
        let url = PlaylistEndpoint.create.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postMyPlaylist - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ postMyPlaylist - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PlaylistDetail.self, from: data)
        } catch {
            print("❌ postMyPlaylist - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getPlaylists() async throws -> [Playlist] {
        let url = PlaylistEndpoint.list.url
        
        let (data, response) = try await session.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getPlaylists] Status code: \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PlaylistResponse.self, from: data).results
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ [getPlaylists] Missing key '\(key.stringValue)' - \(context.debugDescription)")
            throw APError.invalidData
        } catch DecodingError.typeMismatch(let type, let context) {
            print("❌ [getPlaylists] Type mismatch for type '\(type)' - \(context.debugDescription)")
            throw APError.invalidData
        } catch DecodingError.valueNotFound(let type, let context) {
            print("❌ [getPlaylists] Value not found for type '\(type)' - \(context.debugDescription)")
            throw APError.invalidData
        } catch DecodingError.dataCorrupted(let context) {
            print("❌ [getPlaylists] Data corrupted - \(context.debugDescription)")
            throw APError.invalidData
        } catch {
            print("❌ [getPlaylists] Decoding error: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsByIdUser(idUser: Int) async throws -> [Playlist] {
        let url = PlaylistEndpoint.byUser(idUser).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ [getPlaylistsByIdUser] Response error: \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PlaylistResponse.self, from: data).results
        } catch {
            print("❌ [getPlaylistsByIdUser] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsBySlug(slug: String) async throws -> PlaylistDetail {
        print("getPlaylistsBySlug")
        let url = PlaylistEndpoint.bySlug(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ [getPlaylistsBySlug] Response error: \(httpResponse.statusCode) for slug: \(slug)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PlaylistDetail.self, from: data)
        } catch {
            print("❌ [getPlaylistsBySlug] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsBySlugGenre(slug: String) async throws -> [Playlist] {
        let url = PlaylistEndpoint.byGenre(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ [getPlaylistsBySlugGenre] Response error: \(httpResponse.statusCode) for genre: \(slug)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PlaylistResponse.self, from: data).results
        } catch {
            print("❌ [getPlaylistsBySlugGenre] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func getPlaylistsFavorite() async throws -> [FavoritePlaylistItem] {
        let url = PlaylistEndpoint.favorite.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ [getPlaylistsFavorite] Response error: \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PlaylistFavoriteResponse.self, from: data).results
        } catch {
            print("❌ [getPlaylistsFavorite] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
    
    func postAddFavoritePlaylist(slug: String) async throws {
        let url = PlaylistEndpoint.addFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postAddFavoritePlaylist - Invalid response type")
            throw FavoriteError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400, 409:
            print("ℹ️ postAddFavoritePlaylist - Already in favorites: \(slug)")
            throw FavoriteError.alreadyLiked
        default:
            print("❌ postAddFavoritePlaylist - HTTP error \(httpResponse.statusCode)")
            throw FavoriteError.invalidResponse
        }
    }
    
    func deletePlaylistFavorite(slug: String) async throws {
        let url = PlaylistEndpoint.removeFavorite(slug).url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ deletePlaylistFavorite - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ deletePlaylistFavorite - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
    }
    
    func patchPlaylist(
        slug: String,
        title: String? = nil,
        description: String? = nil,
        isPrivate: Bool? = nil,
        imageData: Data? = nil
    ) async throws -> PatchPlaylistResponse {
        let url = PlaylistEndpoint.update(slug).url
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        func addFormField(name: String, value: String) {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8) { body.append(data) }
            if let data = "\(value)\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let title = title { addFormField(name: "title", value: title) }
        if let description = description { addFormField(name: "description", value: description) }
        if let isPrivate = isPrivate { addFormField(name: "is_private", value: "\(isPrivate)") }
        
        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"playlist_image.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ patchPlaylist - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ patchPlaylist - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(PatchPlaylistResponse.self, from: data)
            return result
        } catch {
            print("❌ patchPlaylist - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
}
