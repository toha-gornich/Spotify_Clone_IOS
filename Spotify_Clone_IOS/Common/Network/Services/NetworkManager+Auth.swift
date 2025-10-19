//
//  NetworkManager+Auth.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//

import Foundation


extension NetworkManager: AuthServiceProtocol {
    func postRegUser(regUser: RegUser) async throws -> RegUserResponse {
        guard let url = URL(string: Constants.API.regUserURL) else {
            print("❌ postRegUser - Invalid URL: \(Constants.API.regUserURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(regUser)
        } catch {
            print("❌ postRegUser - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postRegUser - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postRegUser - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postRegUser - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(RegUserResponse.self, from: data)
            } catch {
                print("❌ postRegUser - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postRegUser - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postRegUser - Network error: \(error)")
            throw error
        }
    }

    func postLogin(loginRequest: LoginRequest) async throws -> LoginResponse {
        guard let url = URL(string: Constants.API.createTokenURL) else {
            print("❌ postLogin - Invalid URL: \(Constants.API.createTokenURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(loginRequest)
        } catch {
            print("❌ postLogin - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postLogin - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postLogin - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postLogin - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(LoginResponse.self, from: data)
            } catch {
                print("❌ postLogin - Failed to decode response: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postLogin - Raw response: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postLogin - Network error: \(error)")
            throw error
        }
    }

    func postVerifyToken(tokenVerifyRequest: TokenVerifyRequest) async throws {
        guard let url = URL(string: Constants.API.verifyTokenURL) else {
            print("❌ postVerifyToken - Invalid URL: \(Constants.API.verifyTokenURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(tokenVerifyRequest)
        } catch {
            print("❌ postVerifyToken - Failed to encode request: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postVerifyToken - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postVerifyToken - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postVerifyToken - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ postVerifyToken - Network error: \(error)")
            throw error
        }
    }

    func postActivateAccount(activationRequest: AccountActivationRequest) async throws {
        guard let url = URL(string: Constants.API.activationEmailURL) else {
            print("❌ postActivateAccount - Invalid URL: \(Constants.API.activationEmailURL)")
            throw APError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(activationRequest)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postActivateAccount - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postActivateAccount - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postActivateAccount - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ postActivateAccount - Error: \(error)")
            throw error
        }
    }
    
}
