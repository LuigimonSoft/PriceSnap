//
//  PriceSnapApp.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-01.
//

import SwiftData
import SwiftUI

@main
struct PriceSnapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Product.self, Store.self, PriceFoundByStore.self])
    }
}
