//
//  Store.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//
import Foundation

struct Store: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let link: String
    let image: String
    let description: String
}
