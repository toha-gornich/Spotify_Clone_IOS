//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class GenresViewModelTests: XCTestCase {

    var sut: GenresViewModel!
    var mockService: MockGenreService!

    override func setUp() {
        super.setUp()
        mockService = MockGenreService()
        sut = GenresViewModel(genreManager: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - getGenres

    func test_getGenres_success_populatesGenres() async {
        mockService.mockGenres = [Genre.empty(), Genre.empty()]

        sut.getGenres()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.genres.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getGenres_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getGenres()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getGenreBySlug

    func test_getGenreBySlug_success_setsGenre() async {
        mockService.mockGenre = Genre(id: 1, slug: "pop", name: "Pop", image: "pop.jpg", color: "#FFFFFF")

        sut.getGenreBySlug(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.genre.slug, "pop")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getGenreBySlug_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getGenreBySlug(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getTracksBySlugGenre

    func test_getTracksBySlugGenre_success_populatesTracks() async {
        mockService.mockTracks = [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]

        sut.getTracksBySlugGenre(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.tracks.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getTracksBySlugGenre_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getTracksBySlugGenre(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - getPlaylistsBySlugGenre

    func test_getPlaylistsBySlugGenre_success_populatesPlaylists() async {
        mockService.mockPlaylists = [Playlist.empty, Playlist.empty]

        sut.getPlaylistsBySlugGenre(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.playlists.count, 2)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getPlaylistsBySlugGenre_failure_setsAlertItem() async {
        mockService.shouldFail = true

        sut.getPlaylistsBySlugGenre(slug: "pop")
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
}
