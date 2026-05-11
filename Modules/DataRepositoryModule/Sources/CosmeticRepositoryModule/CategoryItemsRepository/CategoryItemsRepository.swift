//
//  CategoryItemsRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import Foundation
import CoreRepositoryModule

public protocol ICategoryItemsRepository: Actor {

    func loadItems(by category: UUID, itemsPerPage: Int) async throws -> [CategoryItemDTO]
}

extension CosmeticRepository: ICategoryItemsRepository {

    public func loadItems(by category: UUID, itemsPerPage: Int) async throws -> [CategoryItemDTO] {
        try await persistentController.perform { context in
            let request: NSFetchRequest<ItemSummaryEntity> = ItemSummaryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category.id == %@", category as CVarArg)
            request.fetchBatchSize = itemsPerPage

            let items: [ItemSummaryEntity]
            do {
                items = try context.fetch(request)
            } catch {
                throw DataRepositoryError.dataCorrupted(
                    name: category.uuidString,
                    error: error
                )
            }

            return try items.map { item in
                guard let id = item.id,
                      let categoryId = item.category?.id else {
                    throw DataRepositoryError.dataCorrupted(name: item.name, error: nil)
                }

                return .init(
                    id: id,
                    categoryId: categoryId,
                    name: item.name ?? "",
                    photoId: item.photoId,
                    purchaseDate: item.purchaseDate ?? Date(),
                    openDate: item.openDate,
                    paoDate: item.paoDate,
                    expirationDate: item.expirationDate ?? Date()
                )
            }
        }
    }
}
