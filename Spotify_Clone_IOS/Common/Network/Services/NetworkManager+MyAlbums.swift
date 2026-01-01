//
//  NetworkManager+MyAlbums.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation
extension NetworkManager: MyAlbumsServiceProtocol {
    
    func patchAlbumBySlugMy(
        slug: String,
        title: String? = nil,
        description: String? = nil,
        releaseDate: String? = nil,
        isPrivate: Bool? = nil,
        imageData: Data? = nil
    ) async throws -> Album {
        let url = MyAlbumEndpoint.update(slug).url
        
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
        
        if let title = title {
            addFormField(name: "title", value: title)
        }
        if let description = description {
            addFormField(name: "description", value: description)
        }
        if let releaseDate = releaseDate {
            addFormField(name: "release_date", value: releaseDate)
        }
        if let isPrivate = isPrivate {
            addFormField(name: "is_private", value: "\(isPrivate)")
        }
        
        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"album_image.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ patchAlbumMyBySlug - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ patchAlbumMyBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchAlbumMyBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Album.self, from: data)
                return result
            } catch {
                print("❌ patchAlbumMyBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchAlbumMyBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ patchAlbumMyBySlug - Network error: \(error)")
            throw error
        }
    }
    
    func deleteAlbumsMy(slug: String) async throws {
        let url = MyAlbumEndpoint.delete(slug).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteAlbumsMy - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteAlbumsMy - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteAlbumsMy - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteAlbumsMy - Network error: \(error)")
            throw error
        }
    }
    
    func getAlbumsMy() async throws -> [AlbumMy] {
        let url = MyAlbumEndpoint.list.url
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getAlbumsMy - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getAlbumsMy - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsMy - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(AlbumMyResponse.self, from: data).results
            } catch {
                print("❌ getAlbumsMy - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getAlbumsMy - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getAlbumsMy - Network error: \(error)")
            throw error
        }
    }
    
    func postCreateAlbum(
        title: String,
        description: String,
        releaseDate: String,
        isPrivate: Bool,
        imageData: Data?
    ) async throws -> AlbumMy {
        let url = MyAlbumEndpoint.create.url
        
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
        
        addFormField(name: "title", value: title)
        addFormField(name: "description", value: description)
        addFormField(name: "release_date", value: releaseDate)
        addFormField(name: "is_private", value: isPrivate ? "true" : "false")
        
        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"album_cover.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postCreateAlbum - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postCreateAlbum - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateAlbum - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(AlbumMy.self, from: data)
                return result
            } catch {
                print("❌ postCreateAlbum - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateAlbum - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postCreateAlbum - Network error: \(error)")
            throw error
        }
    }
}
