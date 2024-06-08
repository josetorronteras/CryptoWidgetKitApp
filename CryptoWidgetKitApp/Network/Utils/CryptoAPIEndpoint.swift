//
//  CryptoAPIEndpoint.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - CryptoAPIEndpoint
enum CryptoAPIEndpoint {
    case topList(page: Int?)
}

extension CryptoAPIEndpoint {
    
    var url: URL {
        switch self {
        case .topList(let page):
            var components = URLComponents(string: "https://min-api.cryptocompare.com/data/top/totalvolfull")!
            var queryItems = [URLQueryItem(name: "tsym", value: "USD")]
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: String(page)))
            }
            components.queryItems = queryItems
            return components.url!
        }
    }
}
