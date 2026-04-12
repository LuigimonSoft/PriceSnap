import Foundation
import SwiftData

protocol PriceRepository {
    func insert(product: Product, store: Store, price: Double, isOnOffer: Bool, date: Date) throws
}

protocol PriceDatabaseContext {
    func insert(_ priceFoundByStore: PriceFoundByStore)
    func save() throws
}

struct SwiftDataPriceRepository: PriceRepository {
    private let databaseContext: PriceDatabaseContext

    init(modelContext: ModelContext) {
        self.databaseContext = SwiftDataPriceDatabaseContext(modelContext: modelContext)
    }

    init(databaseContext: PriceDatabaseContext) {
        self.databaseContext = databaseContext
    }

    func insert(product: Product, store: Store, price: Double, isOnOffer: Bool, date: Date = .now) throws {
        let priceEntry = PriceFoundByStore(product: product, store: store, price: price, date: date, isOnOffer: isOnOffer)
        databaseContext.insert(priceEntry)
        try databaseContext.save()
    }
}

struct SwiftDataPriceDatabaseContext: PriceDatabaseContext {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insert(_ priceFoundByStore: PriceFoundByStore) {
        modelContext.insert(priceFoundByStore)
    }

    func save() throws {
        try modelContext.save()
    }
}
