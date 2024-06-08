//
//  View+.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 30/5/24.
//

import SwiftUI

extension View {
    
    func errorAlert(isPresented: Binding<Bool>, retryAction: @escaping () -> Void) -> some View {
        alert(isPresented: isPresented) {
            Alert(
                title: Text("An error occurred, try again later"),
                dismissButton: .default(Text("Retry"), action: retryAction)
            )
        }
    }
}
