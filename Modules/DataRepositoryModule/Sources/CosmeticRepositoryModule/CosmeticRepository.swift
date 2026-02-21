//
//  CosmeticRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import CoreRepositoryModule

public final class CosmeticRepository: Sendable {

    let persistentController: CoreRepository
    private let container: NSPersistentContainer

    public init() {
        persistentController = .init()
        container = persistentController.container
    }

    func loadCatalog() async throws -> CatalogEntity? {
        let context = container.newBackgroundContext()
        return try await context.perform {
            let request: NSFetchRequest<CatalogEntity> = CatalogEntity.fetchRequest()
            request.fetchLimit = 1
            return try context.fetch(request).first
        }
    }
}
