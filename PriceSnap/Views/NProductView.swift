//
//  NProductView.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//

import SwiftUI

struct NProductView: View {
    var product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name)
                .font(.headline)

            Text("\(localized("label_barcode")): \(product.barcode)")
                .font(.caption)
                .foregroundStyle(.secondary)

            if product.prices.isEmpty {
                Text(localized("empty_history"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(product.prices.sorted(by: { $0.date > $1.date })) { price in
                    Text("$\(price.price, specifier: "%.2f") • \(price.store.name)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}

#Preview {
    NProductView(product: Product(name: "Sample product", barcode: "0000000000000"))
        .modelContainer(for: [Product.self, Store.self, PriceFoundByStore.self], inMemory: true)
}
