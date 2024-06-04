//
//  CryptoAPIService.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation
import os

// MARK: - CryptoAPIService
class CryptoAPIService {
    
    // MARK: - Dependencies
    private let session: URLSessionProtocol
    
    // MARK: - Properties
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CryptoAPIService.self)
    )
    
    // MARK: - Init
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
}

// MARK: - Public Methods
extension CryptoAPIService {
    
    /// Fetches the list of cryptocurrencies
    /// - Returns: An array of `Crypto` objects.
    func fetchRetrieveTopList(page: Int? = nil) async throws -> Cryptos {
        let request: URLRequest = .init(endpoint: .topList(page: page), method: .get)
        Self.logger.debug("Fetching top list with request: \(request)")
        let (data, _) = try await session.data(for: request)
        Self.logger.debug("Received response with data: \(data)")
        return try JSONDecoder().decode(Cryptos.self, from: data)
    }
}
