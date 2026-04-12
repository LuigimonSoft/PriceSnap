import Foundation
import SwiftData

protocol ProductRepository {
    func fetchAll() throws -> [Product]
    func insert(name: String, barcode: String, image: String) throws
}

protocol ProductDatabaseContext {
    func fetchProducts() throws -> [Product]
    func insert(_ product: Product)
    func save() throws
}

struct SwiftDataProductRepository: ProductRepository {
    private let databaseContext: ProductDatabaseContext

    init(modelContext: ModelContext) {
        self.databaseContext = SwiftDataProductDatabaseContext(modelContext: modelContext)
    }

    init(databaseContext: ProductDatabaseContext) {
        self.databaseContext = databaseContext
    }

    func fetchAll() throws -> [Product] {
        try databaseContext.fetchProducts()
    }

    func insert(name: String, barcode: String, image: String) throws {
        let product = Product(name: name, barcode: barcode, image: image)
        databaseContext.insert(product)
        try databaseContext.save()
    }
}

struct SwiftDataProductDatabaseContext: ProductDatabaseContext {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchProducts() throws -> [Product] {
        let descriptor = FetchDescriptor<Product>(sortBy: [SortDescriptor(\Product.name)])
        return try modelContext.fetch(descriptor)
    }

    func insert(_ product: Product) {
        modelContext.insert(product)
    }

    func save() throws {
        try modelContext.save()
    }
}
