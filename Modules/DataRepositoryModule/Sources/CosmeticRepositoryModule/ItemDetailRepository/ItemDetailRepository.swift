//
//  ItemDetailRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import CoreRepositoryModule

public protocol IItemDetailRepository: Sendable {

    func loadItem(by id: UUID) async throws -> ItemDetailDTO
}

extension CosmeticRepository: IItemDetailRepository {

    public func loadItem(by id: UUID) async throws -> ItemDetailDTO {
        try await persistentController.perform { context in
            let request: NSFetchRequest<ItemDetailEntity> = ItemDetailEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            let item: ItemDetailEntity?
            do {
                item = try context.fetch(request).first
            } catch {
                throw DataRepositoryError.dataCorrupted(name: id.uuidString, error: error)
            }

            guard let item else {
                throw DataRepositoryError.itemNotFound(id: id.uuidString, error: nil)
            }

            guard let id = item.id else {
                throw DataRepositoryError.dataCorrupted(name: id.uuidString, error: nil)
            }

            let photos = (item.photos as? Set<PhotoEntity>)?
                .compactMap { entity -> (id: UUID, categoryId: UUID)? in
                    guard let photoId = entity.id,
                          let categoryId = entity.categoryId else {
                        return nil
                    }

                    return (id: photoId, categoryId: categoryId)
                } ?? []

            return .init(
                id: id,
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

