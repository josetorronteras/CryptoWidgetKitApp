//
//  CryptoTrackingViewModel.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 4/6/24.
//

import Foundation

// MARK: - CryptoTrackingViewModel
@Observable
class CryptoTrackingViewModel {

    // MARK: - Published Properties
    private(set) var trackingCryptos = Set<String>()

    // MARK: - Private Properties
    private let userDefaultKey = "TrackingCryptos"

    // MARK: - Dependencies
    var userDefaults: UserDefaults

    // MARK: - Init
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let cryptos = userDefaults.object(forKey: userDefaultKey) as? [String] {
            self.trackingCryptos = Set(cryptos)
        }
    }
}

// MARK: - Public Methods
extension CryptoTrackingViewModel {
    
    /// Adds or remove the crypto to tracking
    /// - Parameter crypto: Crypto to add or remove
    func toggleTrackingCrypto(_ crypto: Crypto) {
        if trackingCryptos.contains(crypto.coinInfo.id) {
            trackingCryptos.remove(crypto.coinInfo.id)
        } else {
            trackingCryptos.insert(crypto.coinInfo.id)
        }
        userDefaults.set(Array(trackingCryptos), forKey: userDefaultKey)
    }

    /// Check if the crypto is in trackingCryptos  set
    /// - Parameter crypto: Crypto to check
    func contains(_ crypto: Crypto) -> Bool {
        trackingCryptos.contains(crypto.coinInfo.id)
    }
}
