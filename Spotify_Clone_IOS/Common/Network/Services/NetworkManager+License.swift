//
//  NetworkManager+License.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: LicenseServiceProtocol {
    func getLicenses() async throws ->[License] {
        let url = LicenseEndpoint.myLicenses.url
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getLicenses] Response error: \(httpResponse.statusCode)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode([License].self, from: data)
        } catch{
            print("❌ [getLicenses] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }

    func patchLicenseById(id: String, name: String?, text: String?) async throws -> License {
        
        let url = LicenseEndpoint.byID(id).url
        
        var parameters: [String: Any] = [:]
        
        if let name = name {
            parameters["name"] = name
        }
        if let text = text {
            parameters["text"] = text
        }
        
        guard !parameters.isEmpty else {
            print("❌ patchLicenseById - No parameters to update")
            throw APError.invalidData
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("❌ patchLicenseById - Failed to serialize parameters: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ patchLicenseById - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ patchLicenseById - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ patchLicenseById - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
            
            do {
                let license = try decoder.decode(License.self, from: data)
                return license
            } catch {
                print("❌ patchLicenseById - Decoding error: \(error)")
                throw APError.invalidData
            }
        } catch {
            print("❌ patchLicenseById - Network error: \(error)")
            throw error
        }
    }
    
    func postCreateLicense(name: String, text: String) async throws -> License {
        let url = LicenseEndpoint.myLicenses.url
        
        let parameters: [String: Any] = [
            "name": name,
            "text": text
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("❌ postCreateLicense - Failed to serialize parameters: \(error)")
            throw APError.invalidData
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ postCreateLicense - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ postCreateLicense - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateLicense - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            // НЕ використовуємо convertFromSnakeCase, бо у нас є власні CodingKeys
            
            do {
                let license = try decoder.decode(License.self, from: data)
                
                return license
            } catch {
                print("❌ postCreateLicense - Decoding error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ postCreateLicense - Response data: \(responseString)")
                }
                throw APError.invalidData
            }
        } catch {
            print("❌ postCreateLicense - Network error: \(error)")
            throw error
        }
    }
    
    func getLicenseById(id: String) async throws -> License {
        
        let url = LicenseEndpoint.getById(id).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ getLicenseById - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ getLicenseById - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ getLicenseById - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
            
            do {
                let license = try decoder.decode(License.self, from: data)
                return license
            } catch {
                print("❌ getLicenseById - Decoding error: \(error)")
                throw APError.invalidData
            }
        } catch {
            print("❌ getLicenseById - Network error: \(error)")
            throw error
        }
    }

    func deleteLicenseById(id: String) async throws {
        
        let url = LicenseEndpoint.deleteById(id).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ deleteLicenseById - Invalid response type")
                throw APError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ deleteLicenseById - HTTP error \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ deleteLicenseById - Response: \(responseString)")
                }
                throw APError.invalidResponse
            }
        } catch {
            print("❌ deleteLicenseById - Network error: \(error)")
            throw error
        }
    }
}
