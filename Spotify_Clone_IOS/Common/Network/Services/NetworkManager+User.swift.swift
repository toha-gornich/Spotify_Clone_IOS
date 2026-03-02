
//
//  NetworkManager+MyTracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation

extension NetworkManager: UserServiceProtocol {
    
    func getUserMe() async throws -> UserMe {
        let url = UserEndpoint.me.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getUserMe - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getUserMe - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(UserMe.self, from: data)
        } catch {
            print("❌ getUserMe - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getUser(userId: String) async throws -> UserMe {
        print("user user: \(userId)")
        let url = UserEndpoint.byID(userId).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getUser - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getUser - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(UserMe.self, from: data)
        } catch {
            print("❌ getUser - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
    
    func getProfileMy() async throws -> UserMy {
        let url = UserEndpoint.profileMe.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getProfileMy - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getProfileMy - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(UserMy.self, from: data)
        } catch {
            print("❌ getProfileMy - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func putUserMe(user: UpdateUserMe, imageData: Data? = nil) async throws -> UserMy {
        let url = UserEndpoint.updateProfile.url
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
        
        user.displayName.map { addFormField(name: "display_name", value: $0) }
        user.gender.map { addFormField(name: "gender", value: $0) }
        user.country.map { addFormField(name: "country", value: $0) }
        
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
            print("❌ putUserMe - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ putUserMe - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(UserMy.self, from: data)
        } catch {
            print("❌ putUserMe - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func deleteUserMe(password: String) async throws {
        let url = UserEndpoint.me.url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["current_password": password])
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ deleteUserMe - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ deleteUserMe - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
    }
    
    func getFollowers(userId: String) async throws -> [User] {
        let url = UserEndpoint.followers(userId).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getFollowers - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getFollowers - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("❌ getFollowers - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func getFollowing(userId: String) async throws -> [User] {
        let url = UserEndpoint.following(userId).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ getFollowing - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ getFollowing - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("❌ getFollowing - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }
}
