import Foundation
import SwiftData

protocol StoreRepository {
    func fetchAll() throws -> [Store]
    func insert(name: String, location: String, link: String) throws
}

protocol StoreDatabaseContext {
    func fetchStores() throws -> [Store]
    func insert(_ store: Store)
    func save() throws
}

struct SwiftDataStoreRepository: StoreRepository {
    private let databaseContext: StoreDatabaseContext

    init(modelContext: ModelContext) {
        self.databaseContext = SwiftDataStoreDatabaseContext(modelContext: modelContext)
    }

    init(databaseContext: StoreDatabaseContext) {
        self.databaseContext = databaseContext
    }

    func fetchAll() throws -> [Store] {
        try databaseContext.fetchStores()
    }

    func insert(name: String, location: String, link: String) throws {
        let store = Store(name: name, location: location, link: link)
        databaseContext.insert(store)
        try databaseContext.save()
    }
}

struct SwiftDataStoreDatabaseContext: StoreDatabaseContext {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchStores() throws -> [Store] {
        let descriptor = FetchDescriptor<Store>(sortBy: [SortDescriptor(\Store.name)])
        return try modelContext.fetch(descriptor)
    }

    func insert(_ store: Store) {
        modelContext.insert(store)
    }

    func save() throws {
        try modelContext.save()
    }
}
