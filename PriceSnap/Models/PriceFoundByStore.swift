//
//  PriceFoundByStore.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//
import Foundation

struct PriceFoundByStore: Identifiable {
    let id = UUID()
    let productId: UUID
    let storeId: UUID
    let price: Double
    let date: Date
    let isOnOffer: Bool = false
}
