//
//  ResponseModelsTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class ResponseModelsTests: XCTestCase {
    
    func testTracksResponseDecoding() throws {
        let json = """
        {
            "count": 100,
            "next": "http://example.com/next",
            "previous": null,
            "results": []
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(TracksResponse.self, from: data)
        
        XCTAssertEqual(response.count, 100)
        XCTAssertNotNil(response.next)
        XCTAssertNil(response.previous)
    }
    
    func testAlbumResponseDecoding() throws {
        let json = """
        {
            "count": 50,
            "next": null,
            "previous": null,
            "results": []
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(AlbumResponse.self, from: data)
        
        XCTAssertEqual(response.count, 50)
        XCTAssertNil(response.next)
    }
}