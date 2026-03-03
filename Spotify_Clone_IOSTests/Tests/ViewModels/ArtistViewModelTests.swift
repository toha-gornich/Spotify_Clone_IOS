//
//  ArtistViewModelTests.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class ArtistViewModelTests: XCTestCase {

    var sut: ArtistViewModel!
    var mockService: MockArtistService!

    override func setUp() {
        super.setUp()
        mockService = MockArtistService()
        sut = ArtistViewModel(artistManager: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - getArtistsBySlug

    func test_getArtistsBySlug_success_setsArtist() async {
        mockService.mockArtist = makeMockArtist(slug: "test-slug")

        sut.getArtistsBySlug(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.artist.slug, "test-slug")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getArtistsBySlug_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getArtistsBySlug(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getArtistFollowers

    func test_getArtistFollowers_isFollowing_whenSlugMatches() async {
        let artist = makeMockArtist(slug: "test-slug")
        sut.artist = artist
        mockService.mockFavoriteArtists = [makeFavoriteArtistItem(slug: "test-slug")]

        await sut.getArtistFollowers()

        XCTAssertTrue(sut.isFollowing)
    }

    func test_getArtistFollowers_isNotFollowing_whenSlugNotMatches() async {
        sut.artist = makeMockArtist(slug: "my-artist")
        mockService.mockFavoriteArtists = [makeFavoriteArtistItem(slug: "other-artist")]

        await sut.getArtistFollowers()

        XCTAssertFalse(sut.isFollowing)
    }

    func test_getArtistFollowers_failure_setsAlertItem() async {
        mockService.shouldFail = true

        await sut.getArtistFollowers()

        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - followArtist

    func test_followArtist_optimisticallyFollows() {
        sut.followArtist(slug: "test-slug")

        XCTAssertTrue(sut.isFollowing)
    }

    func test_followArtist_failure_revertsFollowing() async {
        mockService.shouldFail = true

        sut.followArtist(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isFollowing)
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - unfollowArtist

    func test_unfollowArtist_optimisticallyUnfollows() {
        sut.isFollowing = true

        sut.unfollowArtist(slug: "test-slug")

        XCTAssertFalse(sut.isFollowing)
    }

    func test_unfollowArtist_failure_revertsUnfollow() async {
        sut.isFollowing = true
        mockService.shouldFail = true

        sut.unfollowArtist(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(sut.isFollowing)
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getArtists

    func test_getArtists_success_populatesArtists() async {
        mockService.mockArtists = [makeMockArtist(slug: "artist-1"), makeMockArtist(slug: "artist-2")]

        sut.getArtists()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.artists.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getArtists_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getArtists()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getTracks

    func test_getTracks_success_populatesPopTracks() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]

        sut.getTracks()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.popTracks.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getTracks_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getTracks()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getTracksBySlugArtist

    func test_getTracksBySlugArtist_success_populatesTracks() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1")]

        sut.getTracksBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.tracks.count, 1)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getTracksBySlugArtist_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getTracksBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getAlbums

    func test_getAlbums_success_populatesAlbums() async {
        mockService.mockAlbums = [Album.empty, Album.empty]

        sut.getAlbums()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.albums.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getAlbums_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getAlbums()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getAlbumsBySlugArtist

    func test_getAlbumsBySlugArtist_success_populatesAlbums() async {
        mockService.mockAlbums = [Album.empty]

        sut.getAlbumsBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.albums.count, 1)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getAlbumsBySlugArtist_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getAlbumsBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
}
