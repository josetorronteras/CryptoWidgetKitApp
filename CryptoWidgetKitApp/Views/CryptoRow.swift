//
//  CryptoRow.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 8/6/24.
//

import SwiftUI

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
