//
//  GenreTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class GenreTests: XCTestCase {
    
    func testGenreDecoding() throws {
        let json = """
        {
            "id": 1,
            "slug": "rock",
            "name": "Rock",
            "image": "rock.jpg",
            "color": "#ff0000"
        }
        """
        
        let data = json.data(using: .utf8)!
        let genre = try JSONDecoder().decode(Genre.self, from: data)
        
        XCTAssertEqual(genre.id, 1)
        XCTAssertEqual(genre.slug, "rock")
        XCTAssertEqual(genre.name, "Rock")
    }
    
    func testGenreEmpty() {
        let genre = Genre.empty()
        XCTAssertEqual(genre.id, 0)
        XCTAssertEqual(genre.name, "")
    }
}