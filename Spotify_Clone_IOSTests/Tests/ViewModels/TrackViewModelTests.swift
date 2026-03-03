//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class TrackViewModelTests: XCTestCase {
    
    var sut: TrackViewModel!
    var mockService: MockTrackService!
    
    override func setUp() {
        super.setUp()
        mockService = MockTrackService()
        sut = TrackViewModel(trackManager: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - getTrackBySlug
    
    func test_getTrackBySlug_success() async {
        let expectedTrack = MockData.trackDetail
        mockService.mockTrackDetail = expectedTrack

        await sut.getTrackBySlug(slug: "test-slug")
        
        XCTAssertEqual(sut.track.slug, expectedTrack.slug)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.alertItem)
    }
    
    func test_getTrackBySlug_failure_setsAlertItem() async {
        mockService.shouldFail = true
        
        await sut.getTrackBySlug(slug: "bad-slug")
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_getTrackBySlug_setsIsLoadingCorrectly() async {
        XCTAssertFalse(sut.isLoading)
        await sut.getTrackBySlug(slug: "test-slug")
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - postTrackFavorite
    
    func test_postTrackFavorite_optimisticallyLikesTrack() {
        sut.postTrackFavorite(slug: "test-slug")
        XCTAssertTrue(sut.isTrackLiked)
    }
    
    func test_postTrackFavorite_failure_revertsLike() async {
        mockService.shouldFail = true
        
        sut.postTrackFavorite(slug: "test-slug")
        
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(sut.isTrackLiked)
        XCTAssertNotNil(sut.alertItem)
    }
    
    // MARK: - deleteTrackFavorite
    
    func test_deleteTrackFavorite_optimisticallyUnlikesTrack() {
        sut.isTrackLiked = true
        
        sut.deleteTrackFavorite(slug: "test-slug")
        
        XCTAssertFalse(sut.isTrackLiked)
    }
    
    func test_deleteTrackFavorite_failure_revertsUnlike() async {
        sut.isTrackLiked = true
        mockService.shouldFail = true
        
        sut.deleteTrackFavorite(slug: "test-slug")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(sut.isTrackLiked)
    }
    
    // MARK: - getTracksLiked

    func test_getTracksLiked_trackIsLiked_whenSlugMatches() async {
        let likedTrack = makeMockTrack(slug: "my-track")
        mockService.mockLikedTracks = [likedTrack]
        sut.currentTrack = likedTrack

        await sut.getTracksLiked()

        XCTAssertTrue(sut.isTrackLiked)
    }

    func test_getTracksLiked_trackIsNotLiked_whenSlugNotMatches() async {
        let otherTrack = makeMockTrack(slug: "other-track")
        let currentTrack = makeMockTrack(slug: "my-track")
        mockService.mockLikedTracks = [otherTrack]
        sut.currentTrack = currentTrack
        await sut.getTracksLiked()

        XCTAssertFalse(sut.isTrackLiked)
    }

    func test_getTracksLiked_failure_setsAlertItem() async {
        mockService.shouldFail = true


        await sut.getTracksLiked()

        XCTAssertNotNil(sut.alertItem)
    }

    // MARK: - getArtists

    func test_getArtists_success_populatesArtists() async {
        mockService.mockArtists = [
            makeMockArtist(slug: "artist-1"),
            makeMockArtist(slug: "artist-2")
        ]

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
    
    // MARK: - handleError
    
    func test_handleError_invalidURL_setsCorrectAlert() {
        sut.handleError(APError.invalidURL)
        
        XCTAssertEqual(sut.alertItem?.title, AlertContext.invalidURL.title)
    }
}
