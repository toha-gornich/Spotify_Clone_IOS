//
//  NetworkManager+Genre.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: GenreServiceProtocol {
    
    func getGenres() async throws -> [Genre] {
        let url = GenreEndpoint.list.url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(GenresResponse.self, from: data).results
        } catch {
            throw APError.invalidData
        }
    }

    func getGenreBySlug(slug: String) async throws -> Genre {
        let url = GenreEndpoint.bySlug(slug).url
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Genre.self, from: data)
        } catch {
            throw APError.invalidData
        }
    }
}
