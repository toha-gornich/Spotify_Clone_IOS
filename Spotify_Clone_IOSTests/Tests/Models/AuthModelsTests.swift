//
//  AuthModelsTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.11.2025.
//


import XCTest
@testable import Spotify_Clone_IOS

class AuthModelsTests: XCTestCase {
    
    func testLoginRequestEncoding() throws {
        let loginRequest = LoginRequest(email: "test@test.com", password: "password123")
        let data = try JSONEncoder().encode(loginRequest)
        let decoded = try JSONDecoder().decode(LoginRequest.self, from: data)
        
        XCTAssertEqual(decoded.email, "test@test.com")
        XCTAssertEqual(decoded.password, "password123")
    }
    
    func testLoginResponseDecoding() throws {
        let json = """
        {
            "access": "access_token_here",
            "refresh": "refresh_token_here"
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        XCTAssertEqual(response.access, "access_token_here")
        XCTAssertEqual(response.refresh, "refresh_token_here")
    }
    
    func testRegUserEncoding() throws {
        let regUser = RegUser(
            email: "test@test.com",
            displayName: "Test User",
            password: "password123",
            rePassword: "password123"
        )
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(regUser)
        
        let json = String(data: data, encoding: .utf8)!
        XCTAssertTrue(json.contains("display_name"))
        XCTAssertTrue(json.contains("re_password"))
    }
}