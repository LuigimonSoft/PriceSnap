import XCTest
@testable import PriceSnap

final class ProductRepositoryTests: XCTestCase {
    func test_GivenProductsInDatabase_WhenFetchAll_ThenReturnProducts_ShouldCallFetchOnContext() throws {
        let mockContext = ProductDatabaseContextMock()
        let expected = [Product(name: "Milk", barcode: "111")]
        mockContext.productsToFetch = expected
        let sut = SwiftDataProductRepository(databaseContext: mockContext)

        let products = try sut.fetchAll()

        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.name, "Milk")
        XCTAssertEqual(mockContext.fetchProductsCallCount, 1)
    }

    func test_GivenValidProductValues_WhenInsert_ThenSaveProduct_ShouldCallInsertAndSave() throws {
        let mockContext = ProductDatabaseContextMock()
        let sut = SwiftDataProductRepository(databaseContext: mockContext)

        try sut.insert(name: "Milk", barcode: "111", image: "milk.png")

        XCTAssertEqual(mockContext.insertedProducts.count, 1)
        XCTAssertEqual(mockContext.insertedProducts.first?.name, "Milk")
        XCTAssertEqual(mockContext.insertedProducts.first?.barcode, "111")
        XCTAssertEqual(mockContext.saveCallCount, 1)
    }
}

final class StoreRepositoryTests: XCTestCase {
    func test_GivenStoresInDatabase_WhenFetchAll_ThenReturnStores_ShouldCallFetchOnContext() throws {
        let mockContext = StoreDatabaseContextMock()
        let expected = [Store(name: "Store A", location: "Paris")]
        mockContext.storesToFetch = expected
        let sut = SwiftDataStoreRepository(databaseContext: mockContext)

        let stores = try sut.fetchAll()

        XCTAssertEqual(stores.count, 1)
        XCTAssertEqual(stores.first?.name, "Store A")
        XCTAssertEqual(mockContext.fetchStoresCallCount, 1)
    }

    func test_GivenValidStoreValues_WhenInsert_ThenSaveStore_ShouldCallInsertAndSave() throws {
        let mockContext = StoreDatabaseContextMock()
        let sut = SwiftDataStoreRepository(databaseContext: mockContext)

        try sut.insert(name: "Store A", location: "Paris", link: "https://store.com")

        XCTAssertEqual(mockContext.insertedStores.count, 1)
        XCTAssertEqual(mockContext.insertedStores.first?.name, "Store A")
        XCTAssertEqual(mockContext.insertedStores.first?.location, "Paris")
        XCTAssertEqual(mockContext.saveCallCount, 1)
    }
}

final class PriceRepositoryTests: XCTestCase {
    func test_GivenValidPriceValues_WhenInsert_ThenSavePriceEntry_ShouldCallInsertAndSave() throws {
        let mockContext = PriceDatabaseContextMock()
        let sut = SwiftDataPriceRepository(databaseContext: mockContext)
        let product = Product(name: "Coffee", barcode: "999")
        let store = Store(name: "Store A", location: "Paris")

        try sut.insert(product: product, store: store, price: 9.99, isOnOffer: true, date: Date(timeIntervalSince1970: 1000))

        XCTAssertEqual(mockContext.insertedPrices.count, 1)
        XCTAssertEqual(mockContext.insertedPrices.first?.price, 9.99)
        XCTAssertEqual(mockContext.insertedPrices.first?.isOnOffer, true)
        XCTAssertEqual(mockContext.saveCallCount, 1)
    }
}

private final class ProductDatabaseContextMock: ProductDatabaseContext {
    var productsToFetch: [Product] = []
    private(set) var insertedProducts: [Product] = []
    private(set) var fetchProductsCallCount = 0
    private(set) var saveCallCount = 0

    func fetchProducts() throws -> [Product] {
        fetchProductsCallCount += 1
        return productsToFetch
    }

    func insert(_ product: Product) {
        insertedProducts.append(product)
    }

    func save() throws {
        saveCallCount += 1
    }
}

private final class StoreDatabaseContextMock: StoreDatabaseContext {
    var storesToFetch: [Store] = []
    private(set) var insertedStores: [Store] = []
    private(set) var fetchStoresCallCount = 0
    private(set) var saveCallCount = 0

    func fetchStores() throws -> [Store] {
        fetchStoresCallCount += 1
        return storesToFetch
    }

    func insert(_ store: Store) {
        insertedStores.append(store)
    }

    func save() throws {
        saveCallCount += 1
    }
}

private final class PriceDatabaseContextMock: PriceDatabaseContext {
    private(set) var insertedPrices: [PriceFoundByStore] = []
    private(set) var saveCallCount = 0

    func insert(_ priceFoundByStore: PriceFoundByStore) {
        insertedPrices.append(priceFoundByStore)
    }

    func save() throws {
        saveCallCount += 1
    }
}
