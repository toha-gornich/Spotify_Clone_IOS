//
//  KeychainManagerTests.swift
//  Spotify_Clone_IOSTests
//
//  Created by Горніч Антон on 27.02.2026.
//

import XCTest
@testable import Spotify_Clone_IOS
final class KeychainManagerTests:XCTestCase{
    
    var sut: KeychainManager!
    
    override func setUp() {
        super.setUp()
        sut = KeychainManager.shared
        
        sut.delete(key: KeychainKey.accessToken.rawValue)
        sut.delete(key: KeychainKey.accessToken.rawValue)
        sut.delete(key: KeychainKey.accessToken.rawValue)
    }
    
    override func tearDown() {
        sut.delete(key: KeychainKey.accessToken.rawValue)
        sut.delete(key: KeychainKey.accessToken.rawValue)
        sut.delete(key: KeychainKey.accessToken.rawValue)
        sut = nil
        super.tearDown()
    }
    
    /// Verifies that a saved value can be read back correctly
    func testSaveAndRead_Success(){
        //Given
        let token = "testToken"
        let data = token.data(using: .utf8)!
        
        //When
        sut.save(key: .accessToken, data: data)
        let result = sut.read(key: .accessToken)
        
        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(String(data: result!, encoding: .utf8), token )
    }
    
    /// Verifies that saving overwrites an existing value
    func testSave_OverwritesExistingValue() {
        //Given
        let oldToken = "oldToken"
        let newToken = "newToken"
        
        //When
        sut.save(key: .accessToken, data: oldToken.data(using: .utf8)!)
        sut.save(key: .accessToken, data: newToken.data(using: .utf8)!)
        let result = sut.read(key: .accessToken)
        
        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(String(data: result!, encoding: .utf8), newToken)
    }
    
    /// Verifies that a deleted key returns nil on read
    func testDelete_RemoveValue() {
        //Given
        let token = "testToken"
        let data = token.data(using: .utf8)!
        
        //When
        sut.save(key: .accessToken, data: data)
        sut.delete(key: KeychainKey.accessToken.rawValue)
        let result = sut.read(key: .accessToken)

        //Then
        XCTAssertNil(result)
    }
    
    
    /// Verifies that reading a non-existent key returns nil
    func testRead_MissingKey_ReturnsNil() {
        let result = sut.read(key: .accessToken)
        
        XCTAssertNil(result)
    }
    
    func testMultipleKeys_StoreIndependently() {
        //Given
        let accessToken = "token1"
        let refreshToken = "token2"
        
        //When
        sut.save(key: .accessToken, data: accessToken.data(using: .utf8)!)
        sut.save(key: .refreshToken, data: refreshToken.data(using: .utf8)!)
        let resultAccessToken = sut.read(key: .accessToken)!
        let resultRefreshToken = sut.read(key: .refreshToken)!
        
        XCTAssertNotNil(accessToken)
        XCTAssertNotNil(refreshToken)
        XCTAssertEqual(String(data: resultAccessToken, encoding: .utf8), accessToken)
        XCTAssertEqual(String(data: resultRefreshToken, encoding: .utf8), refreshToken)
    }
    
}
