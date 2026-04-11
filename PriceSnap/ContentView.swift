//
//  ContentView.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-01.
//

import SwiftUI

struct ContentView: View {
    
    let products: [Product] = [
        Product(name: "Test Product", actualPrice: 10.0, previousPrice: 12.0, maxPrice: 15.0, minPrice: 8.0, barcode: "1234567890123", image: "test_image", storeid: UUID(), previousPriceDate: Date(), previosPriceStoreId: UUID(), maxPriceDate: Date(), minPriceDate: Date(), maxPriceStoreId: UUID(), minPriceStoreId: UUID()),
        Product(name: "Another Product", actualPrice: 20.0, previousPrice: 22.0, maxPrice: 25.0, minPrice: 18.0, barcode: "1234567890124", image: "test_image", storeid: UUID(), previousPriceDate: Date(), previosPriceStoreId: UUID(), maxPriceDate: Date(), minPriceDate: Date(), maxPriceStoreId: UUID(), minPriceStoreId: UUID()),
    ]
    
    let stores: [Store] = [
        Store(name: "Walmart", location: "Canada", link: "https://store1.com", image: "https://brandcenter.walmart.com/content/dam/brand/flower-icon.svg", description: "Description of Store 1"),
        Store(name: "Store 2", location: "Location 2", link: "https://store2.com", image: "store_image", description: "Description of Store 2"),
    ]
    
    
    
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
                        storeView(price: price)
                            
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func storeView(price: PriceFoundByStore) -> some View {
        HStack {
            Text("Price: \(price.price, specifier: "%.2f") at Store ID: \(price.storeId) on \(price.date.formatted())")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var body: some View {
        
        var pricesFound: [PriceFoundByStore] = [
            PriceFoundByStore(productId: products[0].id, storeId: stores[0].id, price: 10.0, date: Date()),
            PriceFoundByStore(productId: products[0].id, storeId: stores[1].id, price: 15.0, date: Date()),
            PriceFoundByStore(productId: products[1].id, storeId: stores[0].id, price: 20.0, date: Date()),
            PriceFoundByStore(productId: products[1].id, storeId: stores[1].id, price: 24.0, date: Date())
        ]
        
        VStack{
            Text("Price Snap")
                .font(.largeTitle)
            HStack {
                Text("Product")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Spacer()
                Text("🔁")
                    .font(.headline)
                    .frame(width: 50, alignment: .center)
                Text("🕒")
                    .font(.headline)
                    .frame(width: 50, alignment: .center)
                Spacer()
                Text("Max")
                    .font(.headline)
                    .frame(width: 45, alignment: .center)
                Text("Min")
                    .font(.headline)
                    .frame(width: 45, alignment: .center)
                    
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            List{
                ForEach(products) { product in
                    productView(product: product, prices: pricesFound.filter { $0.productId == product.id })
                        
                }
                
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
