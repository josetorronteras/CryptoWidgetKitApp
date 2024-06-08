//
//  CryptoWidgetKitApp.swift
//  CryptoWidgetKitApp
//
//  Created by Jose Jesus Torronteras Hernandez on 27/1/24.
//

import SwiftUI

// MARK: - CryptoWidgetKitApp
@main
struct CryptoWidgetKitApp {
    
    static func main() {
        guard isProduction() else {
            TestApp.main()
            return
        }
        ProductionApp.main()
    }
}

// MARK: - Private Methods
private extension CryptoWidgetKitApp {
    
    static func isProduction() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }
}
