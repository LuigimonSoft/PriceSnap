//
//  ContentView.swift
//  PriceSnap
//
//  Created by Luis Carlos Carrillo Tovar on 2025-05-01.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(localized("section_new_product")) {
                    TextField(localized("field_name"), text: $viewModel.newProductName)
                    TextField(localized("field_barcode"), text: $viewModel.newProductBarcode)
                    TextField(localized("field_image"), text: $viewModel.newProductImage)

                    Button(localized("button_save_product")) {
                        viewModel.addProduct()
                    }
                }

                Section(localized("section_new_store")) {
                    TextField(localized("field_name"), text: $viewModel.newStoreName)
                    TextField(localized("field_location"), text: $viewModel.newStoreLocation)
                    TextField(localized("field_website"), text: $viewModel.newStoreLink)

                    Button(localized("button_save_store")) {
                        viewModel.addStore()
                    }
                }

                Section(localized("section_new_price")) {
                    Picker(localized("picker_product"), selection: $viewModel.selectedProductIndex) {
                        Text(localized("picker_select_product")).tag(nil as Int?)
                        ForEach(Array(viewModel.products.enumerated()), id: \.element.persistentModelID) { index, product in
                            Text(product.name).tag(Optional(index))
                        }
                    }

                    Picker(localized("picker_store"), selection: $viewModel.selectedStoreIndex) {
                        Text(localized("picker_select_store")).tag(nil as Int?)
                        ForEach(Array(viewModel.stores.enumerated()), id: \.element.persistentModelID) { index, store in
                            Text(store.name).tag(Optional(index))
                        }
                    }

                    TextField(localized("field_price"), text: $viewModel.newPrice)
                        .keyboardType(.decimalPad)
                    Toggle(localized("toggle_offer"), isOn: $viewModel.isOnOffer)

                    Button(localized("button_save_price")) {
                        viewModel.addPrice()
                    }
                }

                Section(localized("section_registered_products")) {
                    if viewModel.products.isEmpty {
                        Text(localized("empty_products"))
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.products) { product in
                            let summary = viewModel.summary(for: product)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(product.name)
                                    .font(.headline)
                                Text("\(localized("label_barcode")): \(product.barcode)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                HStack {
                                    metricChip(title: localized("metric_current"), value: summary.actualPrice)
                                    metricChip(title: localized("metric_previous"), value: summary.previousPrice)
                                    metricChip(title: localized("metric_max"), value: summary.maxPrice)
                                    metricChip(title: localized("metric_min"), value: summary.minPrice)
                                }

                                if summary.sortedHistory.isEmpty {
                                    Text(localized("empty_history"))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    ForEach(summary.sortedHistory) { priceEntry in
                                        Text("$\(priceEntry.price, specifier: "%.2f") • \(priceEntry.store.name) • \(priceEntry.date.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle(localized("app_title"))
            .onAppear {
                viewModel.configure(with: modelContext)
            }
            .alert(localized("alert_error_title"), isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )) {
                Button(localized("button_ok"), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? localized("error_unknown"))
            }
        }
    }

    @ViewBuilder
    private func metricChip(title: String, value: Double?) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value.map { "$\($0, specifier: "%.2f")" } ?? "—")
                .font(.caption)
                .bold()
        }
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Product.self, Store.self, PriceFoundByStore.self], inMemory: true)
}
