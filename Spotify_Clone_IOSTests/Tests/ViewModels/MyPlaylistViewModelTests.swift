//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class MyPlaylistViewModelTests: XCTestCase {

    var sut: MyPlaylistViewModel!
    var mockPlaylistService: MockPlaylistService!
    var mockSearchService: MockSearchService!

    override func setUp() {
        super.setUp()
        mockPlaylistService = MockPlaylistService()
        mockSearchService = MockSearchService()
        sut = MyPlaylistViewModel(playlistManager: mockPlaylistService, searchManager: mockSearchService)
    }

    override func tearDown() {
        sut = nil
        mockPlaylistService = nil
        mockSearchService = nil
        super.tearDown()
    }

    // MARK: - getPlaylist

    func test_getPlaylist_success_setsPlaylist() async {
        mockPlaylistService.mockPlaylistDetail = makeMockPlaylistDetail(slug: "test-playlist")

        sut.getPlaylist("test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.playlist.slug, "test-playlist")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getPlaylist_failure_setsAlertItem() async {
        mockPlaylistService.shouldFail = true

        sut.getPlaylist("test-playlist")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - patchPlaylist

    func test_patchPlaylist_success_returnsTrue() async {
        let result = await sut.patchPlaylist(title: "New Title", description: "Desc", isPrivate: false, imageData: nil)

        XCTAssertTrue(result)
    }

    func test_patchPlaylist_failure_returnsFalse() async {
        mockPlaylistService.shouldFail = true

        let result = await sut.patchPlaylist(title: "New Title", description: "Desc", isPrivate: false, imageData: nil)

        XCTAssertFalse(result)
    }

    // MARK: - addTrack

    func test_addTrack_success_returnsTrue() async {
        mockPlaylistService.mockPlaylistDetail = makeMockPlaylistDetail(slug: "test-playlist")
        sut.playlist = mockPlaylistService.mockPlaylistDetail

        let result = await sut.addTrack("track-slug")

        XCTAssertTrue(result)
    }

    func test_addTrack_failure_returnsFalse() async {
        mockPlaylistService.shouldFail = true

        let result = await sut.addTrack("track-slug")

        XCTAssertFalse(result)
        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - removeTrack

    func test_removeTrack_success_returnsTrue() async {
        mockPlaylistService.mockPlaylistDetail = makeMockPlaylistDetail(slug: "test-playlist")
        sut.playlist = mockPlaylistService.mockPlaylistDetail

        let result = await sut.removeTrack("track-slug")

        XCTAssertTrue(result)
    }

    func test_removeTrack_failure_returnsFalse() async {
        mockPlaylistService.shouldFail = true

        let result = await sut.removeTrack("track-slug")

        XCTAssertFalse(result)
        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - deletePlaylist

    func test_deletePlaylist_success_setsIsLoadingFalse() async {
        await sut.deletePlaylist()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.alertItem)
    }

    func test_deletePlaylist_failure_setsAlertItem() async {
        mockPlaylistService.shouldFail = true

        await sut.deletePlaylist()

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - isTrackInPlaylist

    func test_isTrackInPlaylist_returnsTrue_whenTrackExists() {
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

        XCTAssertTrue(sut.isTrackInPlaylist("track-1"))
    }

    func test_isTrackInPlaylist_returnsFalse_whenTrackNotExists() {
        sut.playlist = PlaylistDetail.empty

        XCTAssertFalse(sut.isTrackInPlaylist("track-1"))
    }

    // MARK: - searchTracks

    func test_searchTracks_emptyText_clearsResults() {
        sut.searchResults = [makeMockTrack(slug: "track-1")]

        sut.searchTracks(searchText: "")

        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertFalse(sut.isSearching)
    }

    func test_searchTracks_success_populatesResults() async {
        mockSearchService.mockTracksResponse = TracksResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]
        )

        sut.searchTracks(searchText: "test")
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(sut.searchResults.count, 2)
        XCTAssertFalse(sut.isSearching)
    }

    // MARK: - clearSearch

    func test_clearSearch_clearsResultsAndStopsSearching() {
        sut.searchResults = [makeMockTrack(slug: "track-1")]
        sut.isSearching = true

        sut.clearSearch()

        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertFalse(sut.isSearching)
    }
}
