//
//  AuthServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 25.02.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class AuthServiceTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        sut = NetworkManager(session: session)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubHTTPResponse = nil
        MockURLProtocol.stubResponseData = nil
        super.tearDown()
    }
    
    /// Tests that a login token is successfully created and parsed when valid credentials are provided.
    func test_createToken_successfully() async {
        // Given
        stubResponse(file: "token_response", url: AuthEndpoint.createToken.url)
        let loginRequest = LoginRequest(email: "horn@gmail.com", password: "pass12345")
        
        // When
        do {
            let response = try await sut.postLogin(loginRequest: loginRequest)
            // Then
            XCTAssertFalse(response.access.isEmpty)
            XCTAssertFalse(response.refresh.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Tests that the service returns an invalid response error when the server responds with a 401 status code.
    func test_createToken_invalidCredentials() async {
        // Given
        stubResponse(file: "token_response", url: AuthEndpoint.createToken.url, statusCode: 401)
        let loginRequest = LoginRequest(email: "wrong@gmail.com", password: "wrong")
        
        // When
        do {
            _ = try await sut.postLogin(loginRequest: loginRequest)
            XCTFail("expected failed, got success")
        } catch {
            // Then
            XCTAssertEqual(error as? APError, .invalidResponse )
        }
    }
    
    /// Tests that the service throws a data corruption error when the server returns non-JSON or malformed data.
    func test_createToken_invalidJSON() async {
        // Given
        MockURLProtocol.stubResponseData = Data("invalid response".utf8)
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: AuthEndpoint.createToken.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let loginRequest = LoginRequest(email: "horn@gmail.com", password: "pass12345")
        
        // When
        do {
            _ = try await sut.postLogin(loginRequest: loginRequest)
            XCTFail("expected failed, got success")
        } catch {
            // Then
            XCTAssertEqual(error as? APError, .invalidData)
        }
    }
    
    /// Tests the service behavior when there is a connectivity issue, such as no internet connection.
    func test_createToken_networkError() async {
        // Given
        MockURLProtocol.stubError = URLError(.notConnectedToInternet)
        
        let loginRequest = LoginRequest(email: "horn@gmail.com", password: "pass12345")
        
        // When
        do {
            _ = try await sut.postLogin(loginRequest: loginRequest)
            XCTFail("expected failed, got success")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }
    
    /// Tests that a new user is correctly registered and the profile data is properly mapped from the response.
    func test_Register_successfully() async {
        // Given
        stubResponse(file: "created_user_response", url: AuthEndpoint.registerUser.url)
        let regRequest = RegUser(email: "horn@gmail.com",displayName: "lol", password: "pass12345", rePassword:"pass12345")
        
        // When
        do {
            let response = try await sut.postRegUser(regUser: regRequest)
            // Then
            XCTAssertFalse(response.email.isEmpty)
            XCTAssertFalse(response.displayName.isEmpty)
            XCTAssertFalse(response.gender.isEmpty)
            XCTAssertFalse(response.country.isEmpty)
            XCTAssertFalse(response.typeProfile.isEmpty)
            XCTAssertFalse(response.image.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Tests the token verification endpoint to ensure it completes successfully with a valid token.
    func test_verifyToken_successfully() async {
        // Given
        stubResponse(file: "token_response", url: AuthEndpoint.verifyToken.url)
        let loginRequest = TokenVerifyRequest(token: "token")
        
        // When/Then
        do {
            _ = try await sut.postVerifyToken(tokenVerifyRequest: loginRequest)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Tests that the account activation process completes without errors when the correct UID and token are sent.
    func test_activationAccount_successfully() async {
        // Given
        stubResponse(file: nil, url: AuthEndpoint.activationEmail.url)
        let activationRequest = AccountActivationRequest(uid: "uid", token: "token")
        
        // When/Then
        do {
            _ = try await sut.postActivateAccount(activationRequest: activationRequest)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
}

