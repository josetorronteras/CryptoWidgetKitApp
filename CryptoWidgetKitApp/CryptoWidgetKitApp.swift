//
//  CryptoWidgetKitApp.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 27/1/24.
//

import SwiftUI

@main
struct CryptoWidgetKitApp {
    
    static func main() {
        guard isProduction() else {
            TestApp.main()
            return
        }
        ProductionApp.main()
    }
    
    private static func isProduction() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }
}

// MARK: - ProductionApp
struct ProductionApp: App {
    
    @State var cryptoViewModel = CryptoDataViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cryptoViewModel)
        }
    }
}

// MARK: - TestApp
struct TestApp: App {
    var body: some Scene {
        WindowGroup {}
    }
}
