//
//  Extensions+XCTestCase.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 28.02.2026.
//

import XCTest

extension XCTestCase {
    
    func stubResponse(file: String? = nil, url: URL, statusCode: Int = 200) {
        if let file = file {
            guard let path = Bundle(for: type(of: self))
                .url(forResource: file, withExtension: "json"),
                  let data = try? Data(contentsOf: path)
            else {
                XCTFail("Missing \(file).json in test bundle")
                return
            }
            MockURLProtocol.stubResponseData = data
        }
        
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
