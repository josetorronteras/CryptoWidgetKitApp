//
//  CryptoAPIEndpoint.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - CryptoAPIEndpoint
enum CryptoAPIEndpoint {
    case fullList
}

extension CryptoAPIEndpoint {
    
    var url: URL {
        switch self {
        case .fullList:
            URL(string: "https://min-api.cryptocompare.com/data/top/totalvolfull?tsym=USD")!
        }
    }
}
