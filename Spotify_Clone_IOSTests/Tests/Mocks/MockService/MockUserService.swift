//
//  MockUserService.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//


import XCTest
@testable import Spotify_Clone_IOS

class MockUserService: UserServiceProtocol {
    var shouldFail = false
    var mockUserMy = UserMy.empty()
    var mockUserMe = UserMe.empty()

    func getUserMe() async throws -> UserMe {
        if shouldFail { throw APError.invalidData }
        return mockUserMe
    }

    func getUser(userId: String) async throws -> UserMe {
        if shouldFail { throw APError.invalidData }
        return mockUserMe
    }

    func getProfileMy() async throws -> UserMy {
        if shouldFail { throw APError.invalidData }
        return mockUserMy
    }

    func putUserMe(user: UpdateUserMe, imageData: Data?) async throws -> UserMy {
        if shouldFail { throw APError.unableToComplete }
        return mockUserMy
    }

    func deleteUserMe(password: String) async throws {
        if shouldFail { throw APError.unableToComplete }
    }

    func getFollowers(userId: String) async throws -> [User] {
        if shouldFail { throw APError.invalidData }
        return []
    }

    func getFollowing(userId: String) async throws -> [User] {
        if shouldFail { throw APError.invalidData }
        return []
    }
}