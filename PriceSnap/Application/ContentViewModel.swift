import Foundation
import SwiftData

@MainActor
final class ContentViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var stores: [Store] = []
    @Published var errorMessage: String?

    @Published var newProductName = ""
    @Published var newProductBarcode = ""
    @Published var newProductImage = ""

    @Published var newStoreName = ""
    @Published var newStoreLocation = ""
    @Published var newStoreLink = ""

    @Published var selectedProductIndex: Int?
    @Published var selectedStoreIndex: Int?
    @Published var newPrice = ""
    @Published var isOnOffer = false

    private var catalogService: CatalogService?

    func configure(with modelContext: ModelContext) {
        guard catalogService == nil else { return }

        catalogService = CatalogService(
            productRepository: SwiftDataProductRepository(modelContext: modelContext),
            storeRepository: SwiftDataStoreRepository(modelContext: modelContext),
            priceRepository: SwiftDataPriceRepository(modelContext: modelContext)
        )

        refresh()
    }

    func refresh() {
        guard let catalogService else { return }

        do {
            products = try catalogService.loadProducts()
            stores = try catalogService.loadStores()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addProduct() {
        guard let catalogService else { return }

        do {
            try catalogService.createProduct(
                name: newProductName,
                barcode: newProductBarcode,
                image: newProductImage
            )
            newProductName = ""
            newProductBarcode = ""
            newProductImage = ""
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addStore() {
        guard let catalogService else { return }

        do {
            try catalogService.createStore(
                name: newStoreName,
                location: newStoreLocation,
                link: newStoreLink
            )
            newStoreName = ""
            newStoreLocation = ""
            newStoreLink = ""
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addPrice() {
        guard
            let catalogService,
            let selectedProductIndex,
            let selectedStoreIndex,
            products.indices.contains(selectedProductIndex),
            stores.indices.contains(selectedStoreIndex),
            let priceValue = Double(newPrice)
        else {
            errorMessage = NSLocalizedString("error_invalid_selection", comment: "")
            return
        }

        do {
            try catalogService.createPrice(
                product: products[selectedProductIndex],
                store: stores[selectedStoreIndex],
                price: priceValue,
                isOnOffer: isOnOffer
            )
            newPrice = ""
            isOnOffer = false
            refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func summary(for product: Product) -> ProductPriceSummary {
        guard let catalogService else {
            return ProductPriceSummary(
                actualPrice: nil,
                previousPrice: nil,
                maxPrice: nil,
                minPrice: nil,
                sortedHistory: []
            )
        }

        return catalogService.summary(for: product)
    }
}
