//
//  NProductView.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-12.
//

import SwiftUI

struct NProductView: View {
    var product: Product
    var pricesFound: [PriceFoundByStore] = []
    
    var body: some View {
        productView(product: product, prices: pricesFound.filter { $0.productId == product.id })
    }
}

@ViewBuilder
func productView(product: Product, prices: [PriceFoundByStore]) -> some View {
    VStack {
        HStack {
            Text(product.name)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(width: 150, alignment: .leading)
            Spacer()
            HStack {
                
                Text("$\(product.actualPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .frame(width: 50, alignment: .trailing)
                Text("$\(product.previousPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .frame(width: 50, alignment: .trailing)
            }
            Spacer()
            HStack {
                Text("$\(product.maxPrice, specifier: "%.2f")")
                    .font(.caption)
                    .frame(width: 45, alignment: .trailing)
                Text("$\(product.minPrice, specifier: "%.2f")")
                    .font(.caption)
                    .frame(width: 45, alignment: .trailing)
            }
            
        }
        VStack {
            List {
                ForEach(prices) { price in
                    //storeView(price: price)
                        
                }
                
            }
        }
    }
}

#Preview {
    NProductView(
        product: Product(
            name: "Product Name",
            actualPrice: 100.0,
            previousPrice: 120.0,
            maxPrice: 150.0,
            minPrice: 90.0,
            barcode: "123456789",
            image: "product_image",
            storeid: UUID(),
            previousPriceDate: Date(),
            previosPriceStoreId: UUID(),
            maxPriceDate: Date(),
            minPriceDate: Date(),
            maxPriceStoreId: UUID(),
            minPriceStoreId: UUID()
        ),
        pricesFound: []
    )
}
