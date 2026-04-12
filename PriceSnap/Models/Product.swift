//
//  Product.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//

import Foundation
import SwiftData

@Model
final class Product {
    var name: String
    @Attribute(.unique) var barcode: String
    var image: String

    @Relationship(deleteRule: .cascade, inverse: \PriceFoundByStore.product)
    var prices: [PriceFoundByStore]

    init(name: String, barcode: String, image: String = "") {
        self.name = name
        self.barcode = barcode
        self.image = image
        self.prices = []
    }
}
