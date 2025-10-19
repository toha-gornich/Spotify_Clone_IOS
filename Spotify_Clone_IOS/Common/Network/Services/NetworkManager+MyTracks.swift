//
//  NetworkManager+MyTracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: MyTracksServiceProtocol {

    

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
    
    func getTrackMyBySlug(slug: String) async throws -> TracksMyBySlug {
        guard let url = URL(string: Constants.API.tracksMyURL + "\(slug)/") else {
            print("❌ getTrackMyBySlug - Invalid URL: \(Constants.API.tracksMyURL + "\(slug)/")")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getTrackMyBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTrackMyBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TracksMyBySlug.self, from: data)
            } catch {
                print("❌ getTrackMyBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getTrackMyBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getTrackMyBySlug - Network error: \(error)")
            throw error
        }
    }
    
    func patchTrackMyBySlug(
        slug: String,
        title: String? = nil,
        albumId: Int? = nil,
        genreId: Int? = nil,
        licenseId: Int? = nil,
        releaseDate: String? = nil,
        isPrivate: Bool? = nil,
        imageData: Data? = nil,
        audioData: Data? = nil
    ) async throws -> TracksMyBySlug {
        guard let url = URL(string: Constants.API.tracksMyURL + "\(slug)/") else {
            print("❌ patchTrackMyBySlug - Invalid URL: \(Constants.API.tracksMyURL + "\(slug)/")")
            throw APError.invalidURL
        }
        
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
        if let licenseId = licenseId {
            addFormField(name: "license", value: "\(licenseId)")
        }
        if let genreId = genreId {
            addFormField(name: "genre", value: "\(genreId)")
        }
        if let albumId = albumId {
            addFormField(name: "album", value: "\(albumId)")
        }
        if let isPrivate = isPrivate {
            addFormField(name: "is_private", value: "\(isPrivate)")
        }
        if let releaseDate = releaseDate {
            addFormField(name: "release_date", value: releaseDate)
        }
        
        // Image
        if let imageData = imageData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"image\"; filename=\"track_image.jpg\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(imageData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        // File (audio)
        if let audioData = audioData {
            if let data = "--\(boundary)\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Disposition: form-data; name=\"file\"; filename=\"track.mp3\"\r\n".data(using: .utf8) { body.append(data) }
            if let data = "Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8) { body.append(data) }
            body.append(audioData)
            if let data = "\r\n".data(using: .utf8) { body.append(data) }
        }
        
        if let data = "--\(boundary)--\r\n".data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ patchTrackMyBySlug - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ patchTrackMyBySlug - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchTrackMyBySlug - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(TracksMyBySlug.self, from: data)
                return result
            } catch {
                print("❌ patchTrackMyBySlug - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchTrackMyBySlug - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ patchTrackMyBySlug - Network error: \(error)")
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
}
