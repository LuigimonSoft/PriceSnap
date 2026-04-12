//
//  PriceFoundByStore.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//

import Foundation
import SwiftData

@Model
final class PriceFoundByStore {
    var product: Product
    var store: Store
    var price: Double
    var date: Date
    var isOnOffer: Bool

    init(product: Product, store: Store, price: Double, date: Date = .now, isOnOffer: Bool = false) {
        self.product = product
        self.store = store
        self.price = price
        self.date = date
        self.isOnOffer = isOnOffer
    }
}
