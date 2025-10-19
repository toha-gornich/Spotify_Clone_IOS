//
//  NetworkManager+Genre.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 19.10.2025.
//
import Foundation

extension NetworkManager: GenreServiceProtocol {
    func getGenres() async throws -> [Genre] {
        guard let url = URL(string: Constants.API.genresURL) else {
            print("❌ [getGenres] Invalid URL")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getGenres] Response error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GenresResponse.self, from: data).results
        } catch {
            print("❌ [getGenres] JSON decoding failed: \(error)")
            throw APError.invalidData
        }
    }

    func getGenreBySlug(slug:String) async throws -> Genre {
        guard let url = URL(string: Constants.API.genresBySlugURL + "\(slug)/") else {
            print("❌ [getGenreBySlug] Invalid URL for slug: \(slug)")
            throw APError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ [getGenreBySlug] Response error: \(httpResponse.statusCode) for slug: \(slug)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(Genre.self, from: data)
        } catch{
            print("❌ [getGenreBySlug] JSON decoding failed: \(error.localizedDescription)")
            throw APError.invalidData
        }
    }
}
