//
//  CryptoViewModel.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - CryptoViewModel
@Observable
final class CryptoViewModel {
    
    // MARK: - Properties
    private(set) var cryptos: [Crypto] = []
    private(set) var isLoading: Bool = true
    var showError: Bool = false
    
    // MARK: - Dependencies
    private let apiService: CryptoAPIService
    
    // MARK: - Init
    init(apiService: CryptoAPIService = CryptoAPIService(),
         initialState: [Crypto] = .mock) {
        self.apiService = apiService
        self.cryptos = initialState
    }
}

// MARK: - Public Methods
extension CryptoViewModel {
    
    /// Fetch the cryptos from API and update the cryptos array
    func fetch() async {
        isLoading = true
        do {
            sleep(3)
            cryptos = try await apiService.fetchRetrieveFullList().data
            isLoading = false
        } catch {
            print(error)
            showError = true
        }
    }
}

// MARK: - Crypto Extension
extension [Crypto] {
    
    /// Mock Crypto
    static var mock: [Crypto] {
        (0..<5).map {
            Crypto(coinInfo: CoinInfo(id: $0.description, name: "name", fullName: "fullName", imageURL: "imageURL"), display: nil)
        }
    }
}
