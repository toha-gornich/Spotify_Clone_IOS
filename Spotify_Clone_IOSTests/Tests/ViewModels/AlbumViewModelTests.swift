//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class AlbumViewModelTests: XCTestCase {

    var sut: AlbumViewModel!
    var mockService: MockArtistService!

    override func setUp() {
        super.setUp()
        mockService = MockArtistService()
        sut = AlbumViewModel(albumManager: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }


    // MARK: - postAlbumFavorite

    func test_postAlbumFavorite_success_setsIsAlbumLiked() async {
        sut.postAlbumFavorite(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(sut.isAlbumLiked)
        XCTAssertFalse(sut.isLoading)
    }

    func test_postAlbumFavorite_failure_revertsLike() async {
        mockService.shouldFail = true

        sut.postAlbumFavorite(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isAlbumLiked)
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - deleteAlbumFavorite

    func test_deleteAlbumFavorite_success_setsIsAlbumLikedFalse() async {
        sut.isAlbumLiked = true

        sut.deleteAlbumFavorite(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isAlbumLiked)
        XCTAssertFalse(sut.isLoading)
    }

    func test_deleteAlbumFavorite_failure_setsAlertItem() async {
        mockService.shouldFail = true
        sut.isAlbumLiked = true

        sut.deleteAlbumFavorite(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getAlbumLicked

    func test_getAlbumLicked_isAlbumLiked_whenSlugMatches() async {
        let album = makeMockAlbum(slug: "test-slug")
        sut.album = album
        mockService.mockFavoriteAlbums = [makeFavoriteAlbumItem(slug: "test-slug")]

        await sut.getAlbumLicked()

        XCTAssertTrue(sut.isAlbumLiked)
    }

    func test_getAlbumLicked_isNotLiked_whenSlugNotMatches() async {
        sut.album = makeMockAlbum(slug: "my-album")
        mockService.mockFavoriteAlbums = [makeFavoriteAlbumItem(slug: "other-album")]

        await sut.getAlbumLicked()

        XCTAssertFalse(sut.isAlbumLiked)
    }

    func test_getAlbumLicked_failure_setsAlertItem() async {
        mockService.shouldFail = true

        await sut.getAlbumLicked()

        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - getAlbumBySlug

    func test_getAlbumBySlug_success_setsAlbum() async {
        mockService.mockAlbums = [makeMockAlbum(slug: "test-slug")]

        sut.getAlbumBySlug(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.album.slug, "test-slug")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getAlbumBySlug_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getAlbumBySlug(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getTracksBySlugAlbum

    func test_getTracksBySlugAlbum_success_populatesTracks() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]

        sut.getTracksBySlugAlbum(slug: "album-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.tracks.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getTracksBySlugAlbum_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getTracksBySlugAlbum(slug: "album-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getTracksBySlugArtist

    func test_getTracksBySlugArtist_success_populatesTracksByArtist() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1")]

        sut.getTracksBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.tracksByArtist.count, 1)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getTracksBySlugArtist_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getTracksBySlugArtist(slug: "artist-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - totalDuration

    func test_totalDuration_returnsCorrectFormat() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]

        sut.getTracksBySlugAlbum(slug: "album-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.totalDuration.isEmpty)
    }
}
