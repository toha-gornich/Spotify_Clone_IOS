//
//  GenreServiceTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 02.03.2026.
//

import XCTest
@testable import Spotify_Clone_IOS

final class GenreServiceTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUp(){
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        sut = NetworkManager(session: session)
    }
    
    override func tearDown(){
        sut = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubHTTPResponse = nil
        MockURLProtocol.stubResponseData = nil
        super.tearDown()
    }

    

}
