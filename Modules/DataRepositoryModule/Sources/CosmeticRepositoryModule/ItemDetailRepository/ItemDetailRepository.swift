//
//  ItemDetailRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import CoreRepositoryModule

public protocol IItemDetailRepository: Sendable {

    func loadItem(
        by id: String,
        itemName: String,
        categoryName: String
    ) async throws -> ItemDetailDTO
}

extension CosmeticRepository: IItemDetailRepository {

    public func loadItem(
        by id: String,
        itemName: String,
        categoryName: String
    ) async throws -> ItemDetailDTO {

        try await persistentController.perform { context in
            let request: NSFetchRequest<ItemDetailEntity> = ItemDetailEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id)

            let item: ItemDetailEntity?
            do {
                item = try context.fetch(request).first
            } catch {
                throw DataRepositoryError
                    .itemNotFound(
                        category: categoryName,
                        item: itemName,
                        error: error
                    )
            }

            guard let item else {
                throw DataRepositoryError.itemNotFound(category: categoryName, item: itemName, error: nil)
            }

            let photos: [String] = (item.photos as? Set<CatalogPhotoEntity>)?.compactMap(\.photoPath) ?? []

            return .init(
                id: item.id ?? "",
                name: item.name ?? "",
                photos: photos,
                expirationDate: item.expirationDate ?? Date(),
                paoDate: item.paoDate ?? Date(),
                purchaseDate: item.purchaseDate ?? Date(),
                openDate: item.openDate,
                notes: item.notes
            )
        }
    }
}

