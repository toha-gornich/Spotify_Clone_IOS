//
//  NetworkManager+Auth.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation
extension NetworkManager: AuthServiceProtocol {
    
    func postRegUser(regUser: RegUser) async throws -> RegUserResponse {
        let url = AuthEndpoint.registerUser.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(regUser)
        } catch {
            print("❌ postRegUser - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postRegUser - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ postRegUser - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(RegUserResponse.self, from: data)
        } catch {
            print("❌ postRegUser - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func postLogin(loginRequest: LoginRequest) async throws -> LoginResponse {
        let url = AuthEndpoint.createToken.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            print("❌ postLogin - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postLogin - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ postLogin - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } catch {
            print("❌ postLogin - Failed to decode response: \(error)")
            throw APError.invalidData
        }
    }

    func postVerifyToken(tokenVerifyRequest: TokenVerifyRequest) async throws {
        let url = AuthEndpoint.verifyToken.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(tokenVerifyRequest)
        } catch {
            print("❌ postVerifyToken - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postVerifyToken - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ postVerifyToken - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
    }

    func postActivateAccount(activationRequest: AccountActivationRequest) async throws {
        let url = AuthEndpoint.activationEmail.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(activationRequest)
        } catch {
            print("❌ postActivateAccount - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ postActivateAccount - Invalid response type")
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ postActivateAccount - HTTP error \(httpResponse.statusCode)")
            throw APError.invalidResponse
        }
    }
}
