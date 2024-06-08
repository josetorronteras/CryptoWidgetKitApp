//
//  CryptoTrackingViewModelTests.swift
//  CryptoWidgetKitAppTests
//
//  Created by Jose Jesus Torronteras Hernandez on 8/6/24.
//

import XCTest
@testable import CryptoWidgetKitApp

// MARK: - CryptoViewModelTests
final class CryptoTrackingViewModelTests: XCTestCase {
    
    private var userDefaults: UserDefaults!
    private var sut: CryptoTrackingViewModel!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "CryptoTrackingViewModelTests")!
        sut = CryptoTrackingViewModel(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removeObject(forKey: "TrackingCryptos")
        userDefaults = nil
        sut = nil
        super.tearDown()
    }
}

// MARK: - Tests
extension CryptoTrackingViewModelTests {
    
    func test_initializationWithUserDefaultsData() {
        // Given
        let cryptoIDs = ["1", "2", "3"]
        userDefaults.set(cryptoIDs, forKey: "TrackingCryptos")
        
        // When
        sut = CryptoTrackingViewModel(userDefaults: userDefaults)
        
        // Then
        XCTAssertEqual(sut.trackingCryptos, Set(cryptoIDs))
    }
    
    func test_toggleTrackingCrypto() {
        // When
        sut.toggleTrackingCrypto(crypto1)
        
        // Then
        XCTAssertTrue(sut.contains(crypto1))
        XCTAssertFalse(sut.contains(crypto2))
        XCTAssertEqual(userDefaults.object(forKey: "TrackingCryptos") as? [String], ["1"])
        
        // When
        sut.toggleTrackingCrypto(crypto1)
        
        // Then
        XCTAssertFalse(sut.contains(crypto1))
        XCTAssertEqual(userDefaults.object(forKey: "TrackingCryptos") as? [String], [])
        
        // When
        sut.toggleTrackingCrypto(crypto2)
        
        // Then
        XCTAssertTrue(sut.contains(crypto2))
        XCTAssertEqual(userDefaults.object(forKey: "TrackingCryptos") as? [String], ["2"])
    }
    
}


// MARK: - Data
fileprivate extension CryptoTrackingViewModelTests {
    
    var crypto1: Crypto {
        Crypto(coinInfo: CoinInfo(id: "1", name: "Bitcoin", fullName: "Bitcoin", imageURL: "imageURL"), display: nil)
    }
    
    var crypto2: Crypto {
        Crypto(coinInfo: CoinInfo(id: "2", name: "Ethereum", fullName: "Ethereum", imageURL: "imageURL"), display: nil)
    }
}
