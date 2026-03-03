//
//  Untitled.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    var sut: SearchViewModel!
    var mockSearchService: MockSearchService!
    var mockUserService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockSearchService = MockSearchService()
        mockUserService = MockUserService()
        sut = SearchViewModel(searchManager: mockSearchService, userManager: mockUserService)
    }
    
    override func tearDown() {
        sut = nil
        mockSearchService = nil
        mockUserService = nil
        super.tearDown()
    }
    
    // MARK: - searchTracks
    
    func test_searchTracks_success_populatesTracks() async {
        mockSearchService.mockTracksResponse = TracksResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]
        )
        
        sut.searchTracks(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.tracks.count, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchTracks_failure_setsAlertItem() async {
        mockSearchService.shouldFail = true
        
        sut.searchTracks(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchTracks_resetsTracksBeforeSearch() async {
        sut.tracks = [makeMockTrack(slug: "old-track")]
        
        sut.searchTracks(searchText: "test")
        
        XCTAssertTrue(sut.tracks.isEmpty)
    }
    
    // MARK: - loadMoreTracks
    
    func test_loadMoreTracks_appendsTracks_whenHasMore() async {
        mockSearchService.mockTracksResponse = TracksResponse(
            count: 4,
            next: "next-page",
            previous: nil,
            results: [makeMockTrack(slug: "track-1"), makeMockTrack(slug: "track-2")]
        )
        
        sut.searchTracks(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        mockSearchService.mockTracksResponse = TracksResponse(
            count: 4,
            next: nil,
            previous: nil,
            results: [makeMockTrack(slug: "track-3"), makeMockTrack(slug: "track-4")]
        )
        
        sut.loadMoreTracks()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.tracks.count, 4)
        XCTAssertFalse(sut.isLoadingMoreTracks)
    }
    
    func test_loadMoreTracks_doesNotLoad_whenNoMore() async {
        mockSearchService.mockTracksResponse = TracksResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockTrack(slug: "track-1")]
        )
        
        sut.searchTracks(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        sut.loadMoreTracks()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.tracks.count, 1)
    }
    
    // MARK: - searchArtists
    
    func test_searchArtists_success_populatesArtists() async {
        mockSearchService.mockArtistsResponse = ArtistResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockArtist(slug: "artist-1"), makeMockArtist(slug: "artist-2")]
        )
        
        sut.searchArtists(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.artists.count, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchArtists_failure_setsAlertItem() async {
        mockSearchService.shouldFail = true
        
        sut.searchArtists(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - loadMoreArtists
    
    func test_loadMoreArtists_appendsArtists_whenHasMore() async {
        mockSearchService.mockArtistsResponse = ArtistResponse(
            count: 4,
            next: "next-page",
            previous: nil,
            results: [makeMockArtist(slug: "artist-1")]
        )
        
        sut.searchArtists(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        mockSearchService.mockArtistsResponse = ArtistResponse(
            count: 4,
            next: nil,
            previous: nil,
            results: [makeMockArtist(slug: "artist-2")]
        )
        
        sut.loadMoreArtists()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.artists.count, 2)
        XCTAssertFalse(sut.isLoadingMoreArtists)
    }
    
    // MARK: - searchAlbums
    
    func test_searchAlbums_success_populatesAlbums() async {
        mockSearchService.mockAlbumsResponse = AlbumResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockAlbum(slug: "album-1"), makeMockAlbum(slug: "album-2")]
        )
        
        sut.searchAlbums(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.albums.count, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchAlbums_failure_setsAlertItem() async {
        mockSearchService.shouldFail = true
        
        sut.searchAlbums(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - searchPlaylists
    
    func test_searchPlaylists_success_populatesPlaylists() async {
        mockSearchService.mockPlaylistsResponse = PlaylistResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [makeMockPlaylist(slug: "playlist-1"), makeMockPlaylist(slug: "playlist-2")]
        )
        
        sut.searchPlaylists(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.playlists.count, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchPlaylists_failure_setsAlertItem() async {
        mockSearchService.shouldFail = true
        
        sut.searchPlaylists(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - searchProfiles
    
    func test_searchProfiles_success_populatesProfiles() async {
        mockSearchService.mockProfilesResponse = UserResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [User.empty, User.empty]
        )
        
        sut.searchProfiles(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.profiles.count, 2)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_searchProfiles_failure_setsAlertItem() async {
        mockSearchService.shouldFail = true
        
        sut.searchProfiles(searchText: "test")
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - getUserMe
    func test_getUserMe_success_setsUser() async {
        mockUserService.mockUserMy = makeMockUserMy()

        sut.getUserMe()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.user.email, "test@test.com")
        XCTAssertFalse(sut.isLoading)
    }
    
    
    func test_getUserMe_failure_setsAlertItem() async {
        mockUserService.shouldFail = true
        
        sut.getUserMe()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(sut.alertItem)
        XCTAssertFalse(sut.isLoading)
    }
}
