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
            List(cryptoViewModel.cryptos, id: \.coinInfo.id) { crypto in
                HStack {
                    Text(crypto.coinInfo.fullName)
                    Spacer()
                    Text(crypto.display?.usd.price ?? "0")
                }
            }
            .redacted(reason: cryptoViewModel.isLoading ? .placeholder : [])
            .task { await cryptoViewModel.fetch() }
            .refreshable { await cryptoViewModel.fetch() }
            .alert(isPresented: $cryptoViewModel.showError, content: {
                Alert(title: Text("An error occurred, try again later"),
                      dismissButton: .default(
                        Text("Retry"),
                        action: {
                            Task {
                                await cryptoViewModel.fetch()
                            }
                        }))
            })
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
