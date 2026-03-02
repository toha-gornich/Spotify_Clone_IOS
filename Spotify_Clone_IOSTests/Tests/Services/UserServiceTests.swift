    //
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class UserServiceTests: XCTestCase {
    
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
    
    /// Verifies successful current user fetch — response contains valid user data
    func test_getUserMe_successfully() async {
        stubResponse(file: "user_me_response", url: UserEndpoint.me.url)
        do {
            let user = try await sut.getUserMe()
            XCTAssertFalse(user.email.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on user fetch throws invalidResponse
    func test_getUserMe_serverError() async {
        stubResponse(url: UserEndpoint.me.url, statusCode: 401)
        do {
            _ = try await sut.getUserMe()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies user fetch by id — response contains valid user data
    func test_getUser_successfully() async {
        let userId = "1"
        stubResponse(file: "user_me_response", url: UserEndpoint.byID(userId).url)
        do {
            let user = try await sut.getUser(userId: userId)
            XCTAssertFalse(user.email.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies current user profile fetch — response contains valid profile data
    func test_getProfileMy_successfully() async {
        stubResponse(file: "user_my_response", url: UserEndpoint.profileMe.url)
        do {
            let profile = try await sut.getProfileMy()
            XCTAssertFalse(profile.displayName?.isEmpty ?? true)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful user profile update — response contains updated profile data
    func test_putUserMe_successfully() async {
        stubResponse(file: "user_my_response", url: UserEndpoint.updateProfile.url)
        let updateUser = UpdateUserMe(id: 1, email: "newemail@gmail.com", displayName: "name", gender: "gender", country: "UK", image: "image")
        do {
            let profile = try await sut.putUserMe(user: updateUser)
            XCTAssertFalse(profile.displayName?.isEmpty ?? true)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful user deletion — server returns 204 without error
    func test_deleteUserMe_successfully() async {
        stubResponse(url: UserEndpoint.me.url, statusCode: 204)
        do {
            try await sut.deleteUserMe(password: "pass12345")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that wrong password on deletion throws invalidResponse
    func test_deleteUserMe_wrongPassword() async {
        stubResponse(url: UserEndpoint.me.url, statusCode: 400)
        do {
            try await sut.deleteUserMe(password: "wrongpass")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies followers fetch — response contains at least one follower
    func test_getFollowers_successfully() async {
        let userId = "1"
        stubResponse(file: "users_response", url: UserEndpoint.followers(userId).url)
        do {
            let followers = try await sut.getFollowers(userId: userId)
            XCTAssertFalse(followers.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies following fetch — response contains at least one user
    func test_getFollowing_successfully() async {
        let userId = "1"
        stubResponse(file: "users_response", url: UserEndpoint.following(userId).url)
        do {
            let following = try await sut.getFollowing(userId: userId)
            XCTAssertFalse(following.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
}
