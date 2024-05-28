//
//  MockURLSession.swift
//  CryptoWidgetKitAppTests
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation
@testable import CryptoWidgetKitApp

// MARK: - MockURLSession
class MockURLSession: URLSessionProtocol {
    
    // MARK: - Properties
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

// MARK: - Public Methods
extension MockURLSession {
    
    // Simulates a network data task and returns the result.
    ///
    /// - Parameter request: The URL request to be performed.
    /// - Returns: A tuple containing the data and the URL response.
    /// - Throws: An error if any of the following conditions occur:
    ///   - A simulated error is set (`error` property is not nil).
    ///   - The data is nil.
    ///   - The response is not an HTTPURLResponse or the status code is not in the 200-299 range.
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let response = response as? HTTPURLResponse,
              200 ... 299 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }
        guard let data = data else { throw NSError(domain: "", code: 0) }
        return (data, response)
    }
}
