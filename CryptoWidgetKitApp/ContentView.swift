//
//  ContentView.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 27/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(CryptoDataViewModel.self) var cryptoDataViewModel
    @Environment(CryptoTrackingViewModel.self) var cryptoTrackingViewModel
    
    var body: some View {
        @Bindable var cryptoViewModel = cryptoDataViewModel
        NavigationStack {
            List {
                // Section for tracking cryptos
                if !cryptoTrackingViewModel.trackingCryptos.isEmpty {
                    Section(header: Text("Favorite Cryptos")) {
                        ForEach(cryptoViewModel.cryptos.filter { cryptoTrackingViewModel.contains($0) }, id: \.coinInfo.id) { crypto in
                            CryptoRow(crypto: crypto, isFavorite: cryptoTrackingViewModel.contains(crypto), action: {
                                cryptoTrackingViewModel.toggleTrackingCrypto(crypto)
                            })
                        }
                    }
                }
                
                // Section for all cryptos
                Section(header: Text("All Cryptos")) {
                    ForEach(cryptoViewModel.cryptos.filter { !cryptoTrackingViewModel.contains($0) }, id: \.coinInfo.id) { crypto in
                        CryptoRow(crypto: crypto, isFavorite: cryptoTrackingViewModel.contains(crypto), action: {
                            cryptoTrackingViewModel.toggleTrackingCrypto(crypto)
                        })
                    }
                }
            }
            
            // Section for load more button
            if !cryptoViewModel.showSkeleton {
                Section {
                    Button(action: {
                        Task {
                            await cryptoViewModel.loadMoreData()
                        }
                    }, label: {
                        if cryptoViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Load more")
                        }
                    })
                }
            }
        }
        .redacted(reason: cryptoViewModel.showSkeleton ? .placeholder : [])
        .task { await cryptoViewModel.fetchInitialData() }
        .refreshable { await cryptoViewModel.refreshData() }
        .errorAlert(isPresented: $cryptoViewModel.showError) {
            Task {
                await cryptoViewModel.refreshData()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Text("API Cache 120 seconds")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - CryptoRow
struct CryptoRow: View {
    let crypto: Crypto
    let isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(crypto.coinInfo.fullName)
            Spacer()
            Text(crypto.display?.usd.price ?? "0")
            Button(action: action) {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(CryptoDataViewModel())
        .environment(CryptoTrackingViewModel())
}
