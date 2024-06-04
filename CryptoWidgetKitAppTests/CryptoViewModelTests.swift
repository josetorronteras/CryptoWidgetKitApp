//
//  CryptoViewModelTests.swift
//  CryptoWidgetKitAppTests
//
//  Created by Jose Jesus Torronteras Hernandez on 3/6/24.
//

import XCTest
@testable import CryptoWidgetKitApp

// MARK: - CryptoViewModelTests
final class CryptoViewModelTests: XCTestCase {
    
    private var session: MockURLSession!
    private var apiService: CryptoAPIService!
    private var sut: CryptoViewModel!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        apiService = CryptoAPIService(session: session)
        sut = CryptoViewModel(apiService: apiService)
    }
    
    override func tearDown() {
        session = nil
        apiService = nil
        sut = nil
        super.tearDown()
    }
}

// MARK: - Tests
extension CryptoViewModelTests {
    
    func test_fetchInitialData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        
        // When
        Task { await sut.fetchInitialData() }
        
        // Then
        await awaitChanges(to: \.showSkeleton, on: sut, timeout: 5.0)
        XCTAssertFalse(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        await awaitChanges(to: \.cryptos, on: sut, timeout: 5.0)
        XCTAssertEqual(sut.cryptos.count, 2)
    }
    
    func test_loadMoreData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        await sut.fetchInitialData()
        
        // When
        session.data = loadMoreData
        session.response = successLoadMoreDataResponse
        await sut.loadMoreData()
        
        // Then
        XCTAssertFalse(sut.showSkeleton)
        await awaitChanges(to: \.isLoading, on: sut, timeout: 5.0)
        XCTAssertFalse(sut.isLoading)
        await awaitChanges(to: \.showError, on: sut, timeout: 5.0)
        XCTAssertFalse(sut.showError)
        await awaitChanges(to: \.cryptos, on: sut, timeout: 5.0)
        XCTAssertEqual(sut.cryptos.count, 4)
    }
    
    func test_refreshData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        await sut.fetchInitialData()
        
        // When
        await sut.refreshData()
        
        // Then
        await awaitChanges(to: \.showSkeleton, on: sut, timeout: 5.0)
        XCTAssertFalse(sut.showSkeleton)
        await awaitChanges(to: \.isLoading, on: sut, timeout: 5.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        await awaitChanges(to: \.cryptos, on: sut, timeout: 5.0)
        XCTAssertEqual(sut.cryptos.count, 2)
    }
    
    func test_fetchData_failure() async {
        // Given
        session.error = URLError(.badServerResponse)
        
        // When
        await sut.fetchInitialData()
        
        // Then
        await awaitChanges(to: \.showSkeleton, on: sut, timeout: 5.0)
        XCTAssertTrue(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        await awaitChanges(to: \.showError, on: sut, timeout: 5.0)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.cryptos.count, [Crypto].mock.count)
    }
}

// MARK: - Data
fileprivate extension CryptoViewModelTests {
    
    var fullListData: Data {
        Data("{\"Data\":[{\"CoinInfo\":{\"Id\":\"1182\",\"Name\":\"BTC\",\"FullName\":\"Bitcoin\",\"Internal\":\"BTC\",\"ImageUrl\":\"/media/37746251/btc.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 68,512.1\",\"CHANGEPCT24HOUR\":\"-0.04\"}}},{\"CoinInfo\":{\"Id\":\"7605\",\"Name\":\"ETH\",\"FullName\":\"Ethereum\",\"Internal\":\"ETH\",\"ImageUrl\":\"/media/37746238/eth.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 3,901.48\",\"CHANGEPCT24HOUR\":\"-0.07\"}}}]}".utf8)
    }

    var loadMoreData: Data {
        Data("{\"Data\":[{\"CoinInfo\":{\"Id\":\"1042\",\"Name\":\"LTC\",\"FullName\":\"Litecoin\",\"Internal\":\"LTC\",\"ImageUrl\":\"/media/37746257/ltc.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 181.1\",\"CHANGEPCT24HOUR\":\"-0.04\"}}},{\"CoinInfo\":{\"Id\":\"02cf57e2-9b3c-4e9f-9f0e-2a1f2f7b7c9d\",\"Name\":\"DOGE\",\"FullName\":\"Dogecoin\",\"Internal\":\"DOGE\",\"ImageUrl\":\"/media/37746886/doge.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 0.002\",\"CHANGEPCT24HOUR\":\"-0.07\"}}}]}".utf8)
    }
    
    var successFullListResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: CryptoAPIEndpoint.topList(page: nil).url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
    
    var successLoadMoreDataResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: CryptoAPIEndpoint.topList(page: 1).url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
}
