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
    
    // MARK: - Dependencies
    private let apiService: CryptoAPIService
    
    // MARK: - Init
    init(apiService: CryptoAPIService = CryptoAPIService()) {
        self.apiService = apiService
    }
}

// MARK: - Public Methods
extension CryptoViewModel {
    
    /// Fetch the cryptos from API and update the cryptos array
    func fetch() async {
        do {
            cryptos = try await apiService.fetchRetrieveFullList().data
        } catch {
            print(error)
        }
    }
}
