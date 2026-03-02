//
//  NetworkManager+License.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: LicenseServiceProtocol {
    
    func getLicenses() async throws -> [License] {
        let url = LicenseEndpoint.myLicenses.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([License].self, from: data)
        } catch {
            throw APError.invalidData
        }
    }

    func patchLicenseById(id: String, name: String?, text: String?) async throws -> License {
        let url = LicenseEndpoint.byID(id).url
        
        var parameters: [String: Any] = [:]
        if let name = name { parameters["name"] = name }
        if let text = text { parameters["text"] = text }
        
        guard !parameters.isEmpty else {
            throw APError.invalidData
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(License.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
    
    func postCreateLicense(name: String, text: String) async throws -> License {
        let url = LicenseEndpoint.myLicenses.url
        
        let parameters: [String: Any] = ["name": name, "text": text]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(License.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
    
    func getLicenseById(id: String) async throws -> License {
        let url = LicenseEndpoint.getById(id).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(License.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }

    func deleteLicenseById(id: String) async throws {
        let url = LicenseEndpoint.deleteById(id).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
    }
}
