//
//  UserTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class UserTests: XCTestCase {
    
    func testUserDecoding() throws {
        let json = """
        {
            "id": 1,
            "display_name": "Test User",
            "type_profile": "Artist",
            "artist_slug": "test-artist",
            "image": "user.jpg",
            "followers_count": 100,
            "is_premium": true
        }
        """
        
        let data = json.data(using: .utf8)!
        let user = try JSONDecoder().decode(User.self, from: data)
        
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.displayName, "Test User")
        XCTAssertTrue(user.isArtist)
        XCTAssertTrue(user.isPremium ?? false)
    }
    
    func testUserIsArtist() {
        let artistUser = User(
            id: 1,
            displayName: "Artist",
            typeProfile: "Artist",
            artistSlug: "test",
            image: "",
            followersCount: 0,
            isPremium: false
        )
        
        let regularUser = User(
            id: 2,
            displayName: "User",
            typeProfile: "User",
            artistSlug: nil,
            image: "",
            followersCount: 0,
            isPremium: false
        )
        
        XCTAssertTrue(artistUser.isArtist)
        XCTAssertFalse(regularUser.isArtist)
    }
    
    func testUserEmpty() {
        let user = User.empty
        XCTAssertEqual(user.id, -1)
        XCTAssertEqual(user.displayName, "")
    }
}