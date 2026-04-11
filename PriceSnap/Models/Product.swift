//
//  Product.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//
import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let actualPrice: Double
    let previousPrice: Double
    let maxPrice: Double
    let minPrice: Double
    let barcode: String
    let image: String
    let storeid: UUID
    let previousPriceDate: Date
    let previosPriceStoreId: UUID
    let maxPriceDate: Date
    let minPriceDate: Date
    let maxPriceStoreId: UUID
    let minPriceStoreId: UUID
}
