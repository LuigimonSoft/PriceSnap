import XCTest
@testable import PriceSnap

final class CatalogServiceTests: XCTestCase {
    func test_GivenEmptyName_WhenCreateProduct_ThenThrowInvalidName_ShouldFailValidation() {
        let sut = makeService()

        XCTAssertThrowsError(try sut.service.createProduct(name: "   ", barcode: "123", image: "")) { error in
            XCTAssertEqual(error as? CatalogServiceError, .invalidName)
        }
    }

    func test_GivenEmptyBarcode_WhenCreateProduct_ThenThrowInvalidBarcode_ShouldFailValidation() {
        let sut = makeService()

        XCTAssertThrowsError(try sut.service.createProduct(name: "Milk", barcode: " ", image: "")) { error in
            XCTAssertEqual(error as? CatalogServiceError, .invalidBarcode)
        }
    }

    func test_GivenInvalidPrice_WhenCreatePrice_ThenThrowInvalidPrice_ShouldFailValidation() {
        let sut = makeService()
        let product = Product(name: "Bread", barcode: "111")
        let store = Store(name: "Store A", location: "Madrid")

        XCTAssertThrowsError(try sut.service.createPrice(product: product, store: store, price: 0, isOnOffer: false)) { error in
            XCTAssertEqual(error as? CatalogServiceError, .invalidPrice)
        }

        XCTAssertThrowsError(try sut.service.createPrice(product: product, store: store, price: -2, isOnOffer: false)) { error in
            XCTAssertEqual(error as? CatalogServiceError, .invalidPrice)
        }
    }

    func test_GivenStoreInputWithSpaces_WhenCreateStore_ThenTrimValues_ShouldPersistCleanData() throws {
        let sut = makeService()

        try sut.service.createStore(name: "  Store A  ", location: "  Paris  ", link: "  https://store.com  ")

        XCTAssertEqual(sut.storeRepository.insertedName, "Store A")
        XCTAssertEqual(sut.storeRepository.insertedLocation, "Paris")
        XCTAssertEqual(sut.storeRepository.insertedLink, "https://store.com")
    }

    func test_GivenProductHistory_WhenSummaryRequested_ThenComputeCurrentPreviousMinMax_ShouldReturnSortedHistory() {
        let sut = makeService()

        let product = Product(name: "Coffee", barcode: "999")
        let storeA = Store(name: "Store A", location: "Paris")
        let storeB = Store(name: "Store B", location: "Lyon")

        let oldest = Date(timeIntervalSince1970: 100)
        let middle = Date(timeIntervalSince1970: 200)
        let newest = Date(timeIntervalSince1970: 300)

        let p1 = PriceFoundByStore(product: product, store: storeA, price: 8.0, date: oldest)
        let p2 = PriceFoundByStore(product: product, store: storeB, price: 12.0, date: middle)
        let p3 = PriceFoundByStore(product: product, store: storeA, price: 10.0, date: newest)

        product.prices = [p1, p2, p3]

        let summary = sut.service.summary(for: product)

        XCTAssertEqual(summary.actualPrice, 10.0)
        XCTAssertEqual(summary.previousPrice, 12.0)
        XCTAssertEqual(summary.maxPrice, 12.0)
        XCTAssertEqual(summary.minPrice, 8.0)
        XCTAssertEqual(summary.sortedHistory.map(\.price), [10.0, 12.0, 8.0])
    }

    private func makeService() -> (
        service: CatalogService,
        productRepository: ProductRepositoryMock,
        storeRepository: StoreRepositoryMock,
        priceRepository: PriceRepositoryMock
    ) {
        let productRepository = ProductRepositoryMock()
        let storeRepository = StoreRepositoryMock()
        let priceRepository = PriceRepositoryMock()

        let service = CatalogService(
            productRepository: productRepository,
            storeRepository: storeRepository,
            priceRepository: priceRepository
        )

        return (service, productRepository, storeRepository, priceRepository)
    }
}

private final class ProductRepositoryMock: ProductRepository {
    private(set) var insertedName: String?
    private(set) var insertedBarcode: String?
    private(set) var insertedImage: String?

    var productsToReturn: [Product] = []

    func fetchAll() throws -> [Product] {
        productsToReturn
    }

    func insert(name: String, barcode: String, image: String) throws {
        insertedName = name
        insertedBarcode = barcode
        insertedImage = image
    }
}

private final class StoreRepositoryMock: StoreRepository {
    private(set) var insertedName: String?
    private(set) var insertedLocation: String?
    private(set) var insertedLink: String?

    var storesToReturn: [Store] = []

    func fetchAll() throws -> [Store] {
        storesToReturn
    }

    func insert(name: String, location: String, link: String) throws {
        insertedName = name
        insertedLocation = location
        insertedLink = link
    }
}

private final class PriceRepositoryMock: PriceRepository {
    private(set) var insertedProduct: Product?
    private(set) var insertedStore: Store?
    private(set) var insertedPrice: Double?
    private(set) var insertedOnOffer: Bool?

    func insert(product: Product, store: Store, price: Double, isOnOffer: Bool, date: Date) throws {
        insertedProduct = product
        insertedStore = store
        insertedPrice = price
        insertedOnOffer = isOnOffer
    }
}
