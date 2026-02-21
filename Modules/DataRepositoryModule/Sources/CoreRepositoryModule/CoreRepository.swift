//
//  CoreRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData

private enum Constants {

    static let modelName = "CosmeticsCatalog"
}

public struct CoreRepository: Sendable {

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        guard let url = Bundle.module.url(forResource: Constants.modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("CoreData model \(Constants.modelName).momd not found in Bundle.module")
        }

        container = NSPersistentContainer(name: Constants.modelName, managedObjectModel: model)

        let desc = NSPersistentStoreDescription(url: Self.storeURL(storeName: Constants.modelName))
        desc.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        desc.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        if inMemory { desc.url = URL(fileURLWithPath: "/dev/null") }
        container.persistentStoreDescriptions = [desc]

        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData load error: \(error)") }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }

    private static func storeURL(storeName: String) -> URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("\(storeName).sqlite")
    }

    @Sendable public func perform<T: Sendable>(
        _ work: @escaping @Sendable (NSManagedObjectContext) throws -> T
    ) async throws -> T {

        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

        return try await context.perform {
            let result = try work(context)
            if context.hasChanges {
                try context.save()
            }
            return result
        }
    }
}
