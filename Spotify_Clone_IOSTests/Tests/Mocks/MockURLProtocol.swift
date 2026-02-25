//
//  MockURLProtocol.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 25.02.2026.
//

import Foundation

/// A mock URLProtocol used to intercept and stub network requests for unit testing.
class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubHTTPResponse: HTTPURLResponse?
    static var stubError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = MockURLProtocol.stubResponseData {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = MockURLProtocol.stubHTTPResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
