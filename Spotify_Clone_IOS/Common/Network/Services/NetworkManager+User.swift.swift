
//
//  NetworkManager+MyTracks.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation

extension NetworkManager: UserServiceProtocol {
    func getUserMe() async throws -> UserMe {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ getUserMe - Invalid URL: \(Constants.API.userMeURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(UserMe.self, from: data)
            } catch {
                print("❌ getUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getUserMe - Network error: \(error)")
            throw error
        }
    }
    
    func getUser(userId: String) async throws -> UserMe {
        guard let url = URL(string: Constants.API.userURL + "\(userId)/") else {
            print("❌ getUserMe - Invalid URL: \(Constants.API.userMeURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(UserMe.self, from: data)
            } catch {
                print("❌ getUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getUserMe - Network error: \(error)")
            throw error
        }
    }
    
    func getProfileMy() async throws -> UserMy {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ getUserMe - Invalid URL: \(Constants.API.profilesMyURL)")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(UserMy.self, from: data)
            } catch {
                print("❌ getUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getUserMe - Network error: \(error)")
            throw error
        }
    }

    func putUserMe(user: UpdateUserMe, imageData: Data? = nil) async throws -> UserMy {
        guard let url = URL(string: Constants.API.profilesMyURL) else {
            print("❌ putUserMe - Invalid URL: \(Constants.API.profilesMyURL)")
            throw APError.invalidURL
        }
        
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
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ putUserMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ putUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(UserMy.self, from: data)
                return result
            } catch {
                print("❌ putUserMe - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ putUserMe - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ putUserMe - Network error: \(error)")
            throw error
        }
    }

    func deleteUserMe(password: String) async throws {
        guard let url = URL(string: Constants.API.userMeURL) else {
            print("❌ deleteUserMe - Invalid URL: \(Constants.API.userMeURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deleteRequest = ["current_password": password]
        
        do {
            let jsonData = try JSONEncoder().encode(deleteRequest)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteUserMe - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteUserMe - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteUserMe - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteUserMe - Network error: \(error)")
            throw error
        }
    }
    
    func getFollowers(userId: String) async throws -> [User] {
        
        guard let url = URL(string: "\(Constants.API.userURL)\(userId)/followers/") else {
            print("❌ getFollowers - Invalid URL: \(Constants.API.userURL)\(userId)/followers")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getFollowers - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getFollowers - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([User].self, from: data)
            } catch {
                print("❌ getFollowers - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getFollowers - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getFollowers - Network error: \(error)")
            throw error
        }
    }

    func getFollowing(userId: String) async throws -> [User] {
        guard let url = URL(string: "\(Constants.API.userURL)\(userId)/following/") else {
            print("❌ getFollowing - Invalid URL: \(Constants.API.userURL)\(userId)/following/")
            throw APError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("❌ getFollowing - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getFollowing - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([User].self, from: data)
            } catch {
                print("❌ getFollowing - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getFollowing - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ getFollowing - Network error: \(error)")
            throw error
        }
    }
}
