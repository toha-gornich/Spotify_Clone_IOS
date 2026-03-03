//
//  ArtistViewModelTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class ProfileViewModelTests: XCTestCase {

    var sut: ProfileViewModel!
    var mockService: MockProfileService!

    override func setUp() {
        super.setUp()
        mockService = MockProfileService()
        sut = ProfileViewModel(profileManager: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - getUserMe

    func test_getUserMe_nilUserId_setsOwnUser() async {
        mockService.mockUserMe = makeMockUserMe()

        await sut.getUserMe(userId: nil)

        XCTAssertEqual(sut.user.email, "test@test.com")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getUserMe_sameUserId_setsOwnUser() async {
        let userMe = makeMockUserMe()
        mockService.mockUserMe = userMe

        await sut.getUserMe(userId: String(userMe.id))

        XCTAssertEqual(sut.user.id, userMe.id)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getUserMe_differentUserId_fetchesOtherUser() async {
        mockService.mockUserMe = makeMockUserMe()

        await sut.getUserMe(userId: "999")

        XCTAssertEqual(sut.user.id, makeMockUserMe().id)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getUserMe_failure_setsAlertItem() async {
        mockService.shouldFail = true

        await sut.getUserMe(userId: nil)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getUserMe_success_setsUserFields() async {
        mockService.mockUserMe = makeMockUserMe()

        await sut.getUserMe(userId: nil)

        XCTAssertEqual(sut.name, "Test User")
        XCTAssertFalse(sut.image.isEmpty)
        XCTAssertEqual(sut.followersCount, "0")
        XCTAssertEqual(sut.followingCount, "0")
        XCTAssertEqual(sut.playlistsCount, "0")
    }

    // MARK: - getFollowers

    func test_getFollowers_success_populatesFollowers() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.mockFollowers = [User.empty, User.empty]
        await sut.getFollowers()

        XCTAssertEqual(sut.followers.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getFollowers_failure_setsAlertItem() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.shouldFail = true
        await sut.getFollowers()

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getFollowing

    func test_getFollowing_success_populatesFollowing() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.mockFollowing = [User.empty, User.empty]
        await sut.getFollowing()

        XCTAssertEqual(sut.following.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getFollowing_failure_setsAlertItem() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.shouldFail = true
        await sut.getFollowing()

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - loadPlaylists

    func test_loadPlaylists_success_populatesPlaylists() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.mockPlaylists = [makeMockPlaylist(slug: "playlist-1"), makeMockPlaylist(slug: "playlist-2")]
        await sut.loadPlaylists()

        XCTAssertEqual(sut.playlists.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadPlaylists_failure_setsAlertItem() async {
        mockService.mockUserMe = makeMockUserMe()
        await sut.getUserMe(userId: nil)

        mockService.shouldFail = true
        await sut.loadPlaylists()

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadPlaylists_doesNotLoad_whenUserIdIsZero() async {
        await sut.loadPlaylists()

        XCTAssertTrue(sut.playlists.isEmpty)
    }
}
