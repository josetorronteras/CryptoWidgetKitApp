//
//  CryptoDataViewModelTests.swift
//  CryptoWidgetKitAppTests
//
//  Created by Jose Jesus Torronteras Hernandez on 3/6/24.
//

import XCTest
@testable import CryptoWidgetKitApp

// MARK: - CryptoViewModelTests
final class CryptoDataViewModelTests: XCTestCase {
    
    private var session: MockURLSession!
    private var apiService: CryptoAPIService!
    private var sut: CryptoDataViewModel!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        apiService = CryptoAPIService(session: session)
        sut = CryptoDataViewModel(apiService: apiService)
    }
    
    override func tearDown() {
        session = nil
        apiService = nil
        sut = nil
        super.tearDown()
    }
}

// MARK: - Tests
extension CryptoDataViewModelTests {
    
    func test_fetchInitialData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        let showSkeletonExpectation = expectation(description: "showSkeleton published property changed")
        let cryptosExpectation = expectation(description: "cryptos published property changed")
        
        withObservationTracking {
            _ = sut.showSkeleton
        } onChange: {
            showSkeletonExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = sut.cryptos
        } onChange: {
            cryptosExpectation.fulfill()
        }
        
        // When
        Task {
            await sut.fetchInitialData()
        }
        
        // Then
        await fulfillment(of: [showSkeletonExpectation, cryptosExpectation], timeout: 5.0)
        XCTAssertFalse(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.cryptos.count, 2)
    }
    
    func test_loadMoreData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        await sut.fetchInitialData()
        
        // Observa los cambios
        let isLoadingExpectation = expectation(description: "isLoading published property changed")
        let cryptosExpectation = expectation(description: "cryptos published property changed")
        
        withObservationTracking {
            _ = sut.isLoading
        } onChange: {
            isLoadingExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = sut.cryptos
        } onChange: {
            cryptosExpectation.fulfill()
        }
        
        // When
        session.data = loadMoreData
        session.response = successLoadMoreDataResponse
        Task {
            await sut.loadMoreData()
        }
        
        // Then
        await fulfillment(of: [isLoadingExpectation, cryptosExpectation], timeout: 5.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.cryptos.count, 4)
    }
    
    func test_refreshData_success() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        await sut.fetchInitialData()
        
        // Observa los cambios
        let showSkeletonExpectation = expectation(description: "showSkeleton published property changed")
        let cryptosExpectation = expectation(description: "cryptos published property changed")
        
        withObservationTracking {
            _ = sut.showSkeleton
        } onChange: {
            showSkeletonExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = sut.cryptos
        } onChange: {
            cryptosExpectation.fulfill()
        }
        
        // When
        Task {
            await sut.refreshData()
        }
        
        // Then
        await fulfillment(of: [showSkeletonExpectation, cryptosExpectation], timeout: 5.0)
        XCTAssertFalse(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.cryptos.count, 2)
    }
    
    func test_fetchData_failure() async {
        // Given
        session.error = URLError(.badServerResponse)
        
        // Observa los cambios
        let showSkeletonExpectation = expectation(description: "showSkeleton published property changed")
        let showErrorExpectation = expectation(description: "showError published property changed")
        
        withObservationTracking {
            _ = sut.showSkeleton
        } onChange: {
            showSkeletonExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = sut.showError
        } onChange: {
            showErrorExpectation.fulfill()
        }
        
        // When
        Task {
            await sut.fetchInitialData()
        }
        
        // Then
        await fulfillment(of: [showSkeletonExpectation, showErrorExpectation], timeout: 5.0)
        XCTAssertTrue(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.cryptos.count, [Crypto].mock.count)
    }
    
    func test_refreshData_failure() async {
        // Given
        session.data = fullListData
        session.response = successFullListResponse
        await sut.fetchInitialData()
        
        // Observa los cambios
        let showSkeletonExpectation = expectation(description: "showSkeleton published property changed")
        let showErrorExpectation = expectation(description: "showError published property changed")
        
        withObservationTracking {
            _ = sut.showSkeleton
        } onChange: {
            showSkeletonExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = sut.showError
        } onChange: {
            showErrorExpectation.fulfill()
        }
        
        // When
        session.error = URLError(.badServerResponse)
        Task {
            await sut.refreshData()
        }
        
        // Then
        await fulfillment(of: [showSkeletonExpectation, showErrorExpectation], timeout: 5.0)
        XCTAssertTrue(sut.showSkeleton)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.cryptos.count, 2)
    }
}

// MARK: - Data
fileprivate extension CryptoDataViewModelTests {
    
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
