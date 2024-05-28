//
//  URLRequest+.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - URLRequest Extension
extension URLRequest {
    
    /// Custom URLRequest init
    /// - Parameters:
    ///   - endpoint: request endpoint
    ///   - method: request method
    init(endpoint: CryptoAPIEndpoint, method: HTTPMethod) {
        self.init(url: endpoint.url)
        httpMethod = method.rawValue
        addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
