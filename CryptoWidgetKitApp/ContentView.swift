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
        NavigationStack {
            List(cryptoViewModel.cryptos, id: \.coinInfo.id) { crypto in
                HStack {
                    Text(crypto.coinInfo.fullName)
                    Spacer()
                    Text(crypto.display?.usd.price ?? "0")
                }
            }
            .task { await cryptoViewModel.fetch() }
        }
    }
}

#Preview {
    ContentView()
        .environment(CryptoViewModel())
}
