//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class PlaylistViewModelTests: XCTestCase {

    var sut: PlaylistViewModel!
    var mockService: MockPlaylistService!

    override func setUp() {
        super.setUp()
        mockService = MockPlaylistService()
        sut = PlaylistViewModel(playlistManager: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - getPlaylistBySlug

    func test_getPlaylistBySlug_success_setsPlaylist() async {
        mockService.mockPlaylistDetail = makeMockPlaylistDetail(slug: "test-playlist")

        sut.getPlaylistBySlug(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.playlist.slug, "test-playlist")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getPlaylistBySlug_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getPlaylistBySlug(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getPlaylistLicked

    func test_getPlaylistLicked_isLiked_whenSlugMatches() async {
        let playlist = makeMockPlaylistDetail(slug: "test-playlist")
        sut.playlist = playlist
        mockService.mockFavoritePlaylists = [makeFavoritePlaylistItem(slug: "test-playlist")]

        await sut.getPlaylistLicked()

        XCTAssertTrue(sut.isPlaylistLiked)
    }

    func test_getPlaylistLicked_isNotLiked_whenSlugNotMatches() async {
        sut.playlist = makeMockPlaylistDetail(slug: "my-playlist")
        mockService.mockFavoritePlaylists = [makeFavoritePlaylistItem(slug: "other-playlist")]

        await sut.getPlaylistLicked()

        XCTAssertFalse(sut.isPlaylistLiked)
    }

    func test_getPlaylistLicked_failure_setsAlertItem() async {
        mockService.shouldFail = true

        await sut.getPlaylistLicked()

        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - postPlaylistFavorite

    func test_postPlaylistFavorite_success_setsIsPlaylistLiked() async {
        sut.postPlaylistFavorite(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(sut.isPlaylistLiked)
        XCTAssertFalse(sut.isLoading)
    }

    func test_postPlaylistFavorite_failure_revertsLike() async {
        mockService.shouldFail = true

        sut.postPlaylistFavorite(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isPlaylistLiked)
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - deletePlaylistFavorite

    func test_deletePlaylistFavorite_success_setsIsPlaylistLikedFalse() async {
        sut.isPlaylistLiked = true

        sut.deletePlaylistFavorite(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isPlaylistLiked)
        XCTAssertFalse(sut.isLoading)
    }

    func test_deletePlaylistFavorite_failure_setsAlertItem() async {
        mockService.shouldFail = true
        sut.isPlaylistLiked = true

        sut.deletePlaylistFavorite(slug: "test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - totalDuration

    func test_totalDuration_returnsMinusOne_whenNoTracks() {
        sut.playlist = PlaylistDetail(
            id: 0,
            slug: "",
            title: "",
            description: nil,
            image: "",
            color: "",
            user: User.empty,
            tracks: nil,
            genre: nil,
            releaseDate: nil,
            isPrivate: false,
            duration: nil,
            favoriteCount: nil,
            createdAt: nil,
            updatedAt: nil
        )

        XCTAssertEqual(sut.totalDuration, "-1")
    }
    
    func test_totalDuration_returnsFormattedDuration_whenTracksExist() {
        sut.playlist = PlaylistDetail(
            id: 1,
            slug: "test",
            title: "Test",
            description: nil,
            image: "",
            color: "",
            user: User.empty,
            tracks: [makeMockTrack(slug: "track-1")],
            genre: nil,
            releaseDate: nil,
            isPrivate: false,
            duration: nil,
            favoriteCount: nil,
            createdAt: nil,
            updatedAt: nil
        )

        XCTAssertNotEqual(sut.totalDuration, "-1")
    }
}
