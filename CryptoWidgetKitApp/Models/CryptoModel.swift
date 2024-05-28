//
//  CryptoModel.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - Cryptos
struct Cryptos: Codable {
    let data: [Crypto]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Crypto
struct Crypto: Codable {
    let coinInfo: CoinInfo
    let display: Display?
    
    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
        case display = "DISPLAY"
    }
}

// MARK: - CoinInfo
struct CoinInfo: Codable {
    let id: String
    let name: String
    let fullName: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullName = "FullName"
        case imageURL = "ImageUrl"
    }
}

// MARK: - Display
struct Display: Codable {
    let usd: DisplayUsd

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - DisplayUsd
struct DisplayUsd: Codable {
    let price: String
    let pct: String
    
    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case pct = "CHANGEPCT24HOUR"
    }
}
