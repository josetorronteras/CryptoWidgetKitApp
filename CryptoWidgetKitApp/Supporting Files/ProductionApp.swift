//
//  ProductionApp.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 4/6/24.
//

import SwiftUI

// MARK: - ProductionApp
struct ProductionApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var cryptoDataViewModel = CryptoDataViewModel()
    @State var cryptoTrackingViewModel = CryptoTrackingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cryptoDataViewModel)
                .environment(cryptoTrackingViewModel)
        }
    }
}
