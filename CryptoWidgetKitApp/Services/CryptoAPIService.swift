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
    private let urlSession: URLSession
    
    // MARK: - Init
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

// MARK: - Public Methods
extension CryptoAPIService {
    
    /// Fetches the list of cryptocurrencies
    /// - Returns: An array of `Crypto` objects.
    func fetchRetrieveFullList() async throws -> Cryptos {
        var request = URLRequest(url: CryptoAPIURLs.fullList.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(Cryptos.self, from: data)
    }
}
