//
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class MyTracksServiceTests: XCTestCase {
    
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
    
    /// Verifies successful my tracks list fetch — response contains at least one track
    func test_getTracksMy_successfully() async {
        stubResponse(file: "my_tracks_response", url: MyTrackEndpoint.list.url)
        do {
            let tracks = try await sut.getTracksMy()
            XCTAssertFalse(tracks.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on my tracks fetch throws invalidResponse
    func test_getTracksMy_serverError() async {
        stubResponse(url: MyTrackEndpoint.list.url, statusCode: 500)
        do {
            _ = try await sut.getTracksMy()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful track fetch by slug — response contains valid track data
    func test_getTrackMyBySlug_successfully() async {
        let slug = "money-power-glory"
        stubResponse(file: "my_track_by_slug_response", url: MyTrackEndpoint.byID(slug).url)
        do {
            let track = try await sut.getTrackMyBySlug(slug: slug)
            XCTAssertFalse(track.slug.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful track creation — response contains valid track data
    func test_postCreateTrack_successfully() async {
        stubResponse(file: "track_response", url: MyTrackEndpoint.create.url, statusCode: 201)
        do {
            let track = try await sut.postCreateTrack(
                title: "Test Track",
                albumId: 1,
                genreId: 1,
                licenseId: 1,
                releaseDate: "2024-01-01",
                isPrivate: false,
                imageData: nil,
                audioData: nil
            )
            XCTAssertFalse(track.title.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on track creation throws invalidResponse
    func test_postCreateTrack_serverError() async {
        stubResponse(url: MyTrackEndpoint.create.url, statusCode: 400)
        do {
            _ = try await sut.postCreateTrack(
                title: "Test Track",
                albumId: 1,
                genreId: 1,
                licenseId: 1,
                releaseDate: "2024-01-01",
                isPrivate: false,
                imageData: nil,
                audioData: nil
            )
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful track patch — response contains updated track data
    func test_patchTrackMyBySlug_successfully() async {
        let slug = "money-power-glory"
        stubResponse(file: "my_track_by_slug_response", url: MyTrackEndpoint.update(slug).url)
        do {
            let track = try await sut.patchTrackMyBySlug(slug: slug, title: "Updated Title")
            XCTAssertFalse(track.slug.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful track privacy update — server returns 200 without error
    func test_patchTracksMy_successfully() async {
        let slug = "money-power-glory"
        stubResponse(url: MyTrackEndpoint.update(slug).url, statusCode: 200)
        do {
            try await sut.patchTracksMy(slug: slug, isPrivate: true)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on privacy update throws invalidResponse
    func test_patchTracksMy_serverError() async {
        let slug = "money-power-glory"
        stubResponse(url: MyTrackEndpoint.update(slug).url, statusCode: 400)
        do {
            try await sut.patchTracksMy(slug: slug, isPrivate: true)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful track deletion — server returns 204 without error
    func test_deleteTracksMy_successfully() async {
        let slug = "money-power-glory"
        stubResponse(url: MyTrackEndpoint.delete(slug).url, statusCode: 204)
        do {
            try await sut.deleteTracksMy(slug: slug)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that deleting non-existent track throws invalidResponse
    func test_deleteTracksMy_notFound() async {
        let slug = "non-existent"
        stubResponse(url: MyTrackEndpoint.delete(slug).url, statusCode: 404)
        do {
            try await sut.deleteTracksMy(slug: slug)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
}
