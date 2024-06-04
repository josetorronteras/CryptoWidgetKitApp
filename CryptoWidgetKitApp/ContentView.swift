//
//  ContentView.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 27/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(CryptoViewModel.self) var cryptoViewModel
    
    var body: some View {
        @Bindable var cryptoViewModel = cryptoViewModel
        NavigationStack {
            List {
                ForEach(cryptoViewModel.cryptos, id: \.coinInfo.id){ crypto in
                    HStack {
                        Text(crypto.coinInfo.fullName)
                        Spacer()
                        Text(crypto.display?.usd.price ?? "0")
                    }
                }
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
}

#Preview {
    ContentView()
        .environment(CryptoViewModel())
}
