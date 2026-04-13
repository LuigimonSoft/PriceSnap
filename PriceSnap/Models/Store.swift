//
//  Store.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//

import Foundation
import SwiftData

@Model
final class Store {
    var name: String
    var location: String
    var link: String
    var image: String
    var storeDescription: String

    @Relationship(deleteRule: .cascade, inverse: \PriceFoundByStore.store)
    var prices: [PriceFoundByStore]

    init(
        name: String,
        location: String,
        link: String = "",
        image: String = "",
        storeDescription: String = ""
    ) {
        self.name = name
        self.location = location
        self.link = link
        self.image = image
        self.storeDescription = storeDescription
        self.prices = []
    }
}
