//
//  LicenseServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class LicenseServiceTests: XCTestCase {
    
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
    
    /// Verifies successful licenses fetch — response contains at least one license
    func test_getLicenses_successfully() async {
        stubResponse(file: "licenses_response", url: LicenseEndpoint.myLicenses.url)
        do {
            let licenses = try await sut.getLicenses()
            XCTAssertFalse(licenses.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that server error on licenses fetch throws invalidResponse
    func test_getLicenses_serverError() async {
        stubResponse(url: LicenseEndpoint.myLicenses.url, statusCode: 500)
        do {
            _ = try await sut.getLicenses()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
    
    /// Verifies successful license creation — response contains valid license data
    func test_postCreateLicense_successfully() async {
        stubResponse(file: "license_id_response", url: LicenseEndpoint.myLicenses.url, statusCode: 201)
        do {
            let license = try await sut.postCreateLicense(name: "Test License", text: "Test Text")
            XCTAssertFalse(license.name.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful license fetch by id — response contains valid license data
    func test_getLicenseById_successfully() async {
        let id = "1"
        stubResponse(file: "license_id_response", url: LicenseEndpoint.getById(id).url)
        do {
            let license = try await sut.getLicenseById(id: id)
            XCTAssertFalse(license.name.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies successful license patch — response contains updated license data
    func test_patchLicenseById_successfully() async {
        let id = "1"
        stubResponse(file: "license_id_response", url: LicenseEndpoint.byID(id).url)
        do {
            let license = try await sut.patchLicenseById(id: id, name: "Updated Name", text: nil)
            XCTAssertFalse(license.name.isEmpty)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that patching with no parameters throws invalidData
    func test_patchLicenseById_noParameters() async {
        let id = "1"
        // ← прибери stubResponse, запит навіть не відправляється
        do {
            _ = try await sut.patchLicenseById(id: id, name: nil, text: nil)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidData)
        }
    }
    
    /// Verifies successful license deletion — server returns 204 without error
    func test_deleteLicenseById_successfully() async {
        let id = "1"
        stubResponse(url: LicenseEndpoint.deleteById(id).url, statusCode: 204)
        do {
            try await sut.deleteLicenseById(id: id)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    /// Verifies that deleting non-existent license throws invalidResponse
    func test_deleteLicenseById_notFound() async {
        let id = "999"
        stubResponse(url: LicenseEndpoint.deleteById(id).url, statusCode: 404)
        do {
            try await sut.deleteLicenseById(id: id)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? APError, .invalidResponse)
        }
    }
}
