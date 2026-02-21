//
//  CategoryItemsRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import Foundation
import CoreRepositoryModule

public protocol ICategoryItemsRepository: Sendable {

    func loadItems(by category: String, itemsPerPage: Int) async throws -> [CategoryItemDTO]
}

extension CosmeticRepository: ICategoryItemsRepository {

    public func loadItems(by category: String, itemsPerPage: Int) async throws -> [CategoryItemDTO] {
        try await persistentController.perform { context in
            let request: NSFetchRequest<ItemSummaryEntity> = ItemSummaryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category.id == %@", category)
            request.sortDescriptors = [
                NSSortDescriptor(key: "sortIndex", ascending: true)
            ]
            request.fetchBatchSize = itemsPerPage

            let items: [ItemSummaryEntity]
            do {
                items = try context.fetch(request)
            } catch {
                throw DataRepositoryError.categoryItemsNotFound(category: category, error: error)
            }

            return items.map {
                .init(
                    id: $0.id ?? "",
                    name: $0.name ?? "",
                    photo: $0.photo?.photoPath,
                    expirationDate: $0.expirationDate ?? Date(),
                    paoDate: $0.paoDate,
                    purchaseDate: $0.purchaseDate ?? Date()
                )
            }
        }
    }
}
