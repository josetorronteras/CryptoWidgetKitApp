//
//  URLSessionProtocol.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - URLSessionProtocol
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSession
extension URLSession: URLSessionProtocol {
    func protocolData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}
