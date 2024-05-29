//
//  CryptoAPIService.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - CryptoAPIService
class CryptoAPIService {
    
    // MARK: - Dependencies
    private let session: URLSessionProtocol
    
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
    func fetchRetrieveFullList() async throws -> Cryptos {
        let request: URLRequest = .init(endpoint: .fullList, method: .get)
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(Cryptos.self, from: data)
    }
}
