//
//  CryptoAPIServiceTests.swift
//  CryptoWidgetKitAppTests
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import XCTest
@testable import CryptoWidgetKitApp

// MARK: - CryptoAPIServiceTests
final class CryptoAPIServiceTests: XCTestCase {
    
    private var session: MockURLSession!
    private var sut: CryptoAPIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockURLSession()
        sut = CryptoAPIService(session: session)
    }
    
    override func tearDownWithError() throws {
        session = nil
        sut = nil
        try super.tearDownWithError()
    }
}

// MARK: - Tests
extension CryptoAPIServiceTests {
    
    func test_fetchRetrieveFullList_success() async throws {
        // given
        session.data = fullListData
        session.response = successFullListResponse
        let expectation = XCTestExpectation(description: "Fetch full list")
        
        // when
        do {
            let result = try await sut.fetchRetrieveFullList()
            // then
            XCTAssertEqual(result.data.count, 2)
            XCTAssertEqual(result.data[0].coinInfo.fullName, "Bitcoin")
            XCTAssertEqual(result.data[1].coinInfo.fullName, "Ethereum")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func test_fetchRetrieveFullList_failureHttpResponse() async throws {
        // given
        session.data = Data()
        session.response = badFullListResponse
        let expectation = XCTestExpectation(description: "Fetch full list")
        
        // when
        do {
            _ = try await sut.fetchRetrieveFullList()
            XCTFail("Expected to throw error, but succeeded")
        } catch {
            // then
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
        
        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func test_fetchRetrieveFullList_failureErrorConnection() async throws {
        // given
        session.error = URLError(.notConnectedToInternet)
        let expectation = XCTestExpectation(description: "Fetch full list")
        
        // when
        do {
            _ = try await sut.fetchRetrieveFullList()
            XCTFail("Expected to throw error, but succeeded")
        } catch {
            // then
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
        
        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 5.0)
    }
}

// MARK: - Data
fileprivate extension CryptoAPIServiceTests {
    
    var fullListData: Data {
        Data("{\"Data\":[{\"CoinInfo\":{\"Id\":\"1182\",\"Name\":\"BTC\",\"FullName\":\"Bitcoin\",\"Internal\":\"BTC\",\"ImageUrl\":\"/media/37746251/btc.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 68,512.1\",\"CHANGEPCT24HOUR\":\"-0.04\"}}},{\"CoinInfo\":{\"Id\":\"7605\",\"Name\":\"ETH\",\"FullName\":\"Ethereum\",\"Internal\":\"ETH\",\"ImageUrl\":\"/media/37746238/eth.png\"},\"DISPLAY\":{\"USD\":{\"PRICE\":\"$ 3,901.48\",\"CHANGEPCT24HOUR\":\"-0.07\"}}}]}".utf8)
    }
    
    var successFullListResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: CryptoAPIEndpoint.fullList.url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
    }
    
    var badFullListResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: CryptoAPIEndpoint.fullList.url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil)!
    }
}
