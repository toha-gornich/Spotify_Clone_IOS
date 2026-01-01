//
//  LicenseTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class LicenseTests: XCTestCase {
    
    func testLicenseDecoding() throws {
        let json = """
        {
            "id": 1,
            "artist": {
                "id": 1,
                "slug": "test-artist",
                "display_name": "Test Artist",
                "image": "artist.jpg",
                "color": "#000000",
                "is_verify": true
            },
            "name": "Test License",
            "text": "License text"
        }
        """
        
        let data = json.data(using: .utf8)!
        let license = try JSONDecoder().decode(License.self, from: data)
        
        XCTAssertEqual(license.id, 1)
        XCTAssertEqual(license.name, "Test License")
        XCTAssertEqual(license.text, "License text")
    }
    
    func testLicenseEmpty() {
        let license = License.empty()
        XCTAssertEqual(license.id, 0)
        XCTAssertEqual(license.name, "")
    }
}