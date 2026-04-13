import Foundation

struct ProductPriceSummary {
    let actualPrice: Double?
    let previousPrice: Double?
    let maxPrice: Double?
    let minPrice: Double?
    let sortedHistory: [PriceFoundByStore]
}

enum CatalogServiceError: LocalizedError, Equatable {
    case invalidName
    case invalidBarcode
    case invalidPrice

    var errorDescription: String? {
        switch self {
        case .invalidName:
            return NSLocalizedString("error_invalid_name", comment: "")
        case .invalidBarcode:
            return NSLocalizedString("error_invalid_barcode", comment: "")
        case .invalidPrice:
            return NSLocalizedString("error_invalid_price", comment: "")
        }
    }
}

struct CatalogService {
    private let productRepository: ProductRepository
    private let storeRepository: StoreRepository
    private let priceRepository: PriceRepository

    init(
        productRepository: ProductRepository,
        storeRepository: StoreRepository,
        priceRepository: PriceRepository
    ) {
        self.productRepository = productRepository
        self.storeRepository = storeRepository
        self.priceRepository = priceRepository
    }

    func loadProducts() throws -> [Product] {
        try productRepository.fetchAll()
    }

    func loadStores() throws -> [Store] {
        try storeRepository.fetchAll()
    }

    func createProduct(name: String, barcode: String, image: String) throws {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBarcode = barcode.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanImage = image.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { throw CatalogServiceError.invalidName }
        guard !cleanBarcode.isEmpty else { throw CatalogServiceError.invalidBarcode }

        try productRepository.insert(name: cleanName, barcode: cleanBarcode, image: cleanImage)
    }

    func createStore(name: String, location: String, link: String) throws {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanLink = link.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { throw CatalogServiceError.invalidName }

        try storeRepository.insert(name: cleanName, location: cleanLocation, link: cleanLink)
    }

    func createPrice(product: Product, store: Store, price: Double, isOnOffer: Bool) throws {
        guard price > 0 else { throw CatalogServiceError.invalidPrice }
        try priceRepository.insert(product: product, store: store, price: price, isOnOffer: isOnOffer, date: .now)
    }

    func summary(for product: Product) -> ProductPriceSummary {
        let sortedHistory = product.prices.sorted { $0.date > $1.date }
        let prices = sortedHistory.map(\.price)

        return ProductPriceSummary(
            actualPrice: sortedHistory.first?.price,
            previousPrice: sortedHistory.count > 1 ? sortedHistory[1].price : nil,
            maxPrice: prices.max(),
            minPrice: prices.min(),
            sortedHistory: sortedHistory
        )
    }
}
