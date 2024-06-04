//
//  CryptoDataViewModel.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 28/5/24.
//

import Foundation

// MARK: - CryptoDataViewModel
@Observable
final class CryptoDataViewModel {
    
    // MARK: - Published Properties
    private(set) var cryptos: [Crypto] = []
    private(set) var showSkeleton: Bool = false
    private(set) var isLoading: Bool = false
    var showError: Bool = false
    
    // MARK: - Private Properties
    private var page: Int = 0 {
        didSet {
            if page < 0 {
                page = 0
            }
        }
    }
    
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
extension CryptoDataViewModel {
    
    /// Fetch the cryptos from API and update the cryptos array
    func fetchInitialData() async {
        showSkeleton = true
        defer { 
            if !showError {
                showSkeleton = false
            }
        }
        await fetchData(page: nil)
    }
    
    /// Load more cryptos from API and append to the cryptos array
    func loadMoreData() async {
        page += 1
        await fetchData(page: page)
    }
    
    /// Refresh all data from API and update the cryptos array
    func refreshData() async {
        showSkeleton = true
        defer {
            if !showError {
                showSkeleton = false
            }
        }
        var allData: [Crypto] = []
        for p in 0...page {
            do {
                let data = try await apiService.fetchRetrieveTopList(page: p).data
                allData.append(contentsOf: data)
            } catch {
                showError = true
                return
            }
        }
        cryptos = allData
    }
}

// MARK: - Private Methods
private extension CryptoDataViewModel {
    
    /// Method to fetch data from API and update the cryptos array
    func fetchData(page: Int?) async {
        if page != nil {
            isLoading = true
        }
        defer { isLoading = false }
        do {
            let data = try await apiService.fetchRetrieveTopList(page: page).data
            if page != nil && page! > 0 {
                cryptos.append(contentsOf: data)
            } else {
                cryptos = data
            }
        } catch {
            showError = true
            self.page = (page ?? 0) - 1
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
