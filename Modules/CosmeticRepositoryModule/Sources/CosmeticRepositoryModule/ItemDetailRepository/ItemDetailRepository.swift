//
//  ItemDetailRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import LoggerModule

public protocol IItemDetailRepository: Sendable {

    func loadItem(of summary: ItemSummaryDTO) async throws -> ItemDetailDTO

    func createItem(
        from summary: ItemSummaryDTO,
        and detail: ItemDetailDTO,
        inCategory category: CategoryDTO
    ) async throws

    func saveItem(
        from summary: ItemSummaryDTO,
        and detail: ItemDetailDTO,
        inCategory category: CategoryDTO
    ) async throws
}

extension CosmeticRepository: IItemDetailRepository {

    public func loadItem(of summary: ItemSummaryDTO) async throws -> ItemDetailDTO {
        try await persistentController.perform { context in
            let detailEntity: ItemDetailEntity = try CosmeticRepository.load(
                itemId: summary.itemDetailId,
                context
            )

            guard detailEntity.id != nil else {
                assertionFailure("У продукта \(summary.name) нет ID")
                throw DataRepositoryError.dataCorrupted(
                    name: summary.name,
                    error: nil,
                    subError: "У продукта нет ID"
                )
            }

            guard let dto = ItemDetailDTO(from: detailEntity) else {
                assertionFailure("В элементе БД отсутствуют необходимые данные")
                throw DataRepositoryError.dataCorrupted(
                    name: summary.name,
                    error: nil,
                    subError: "В элементе БД отсутствуют необходимые данные"
                )
            }

            return dto
        }
    }

    public func createItem(
        from summary: ItemSummaryDTO,
        and detail: ItemDetailDTO,
        inCategory category: CategoryDTO
    ) async throws {

        guard summary.itemDetailId == detail.id,
              summary.categoryId == category.id
        else {
            assertionFailure("ID сущностей должны совпадать")
            throw DataRepositoryError.inputDataCorrupted(
                error: .mutation(name: "ID сущностей должны совпадать")
            )
        }

        try await persistentController.perform { context in
            do {
                if let _: ItemSummaryEntity = try CosmeticRepository.loadItem(
                    byId: summary.id,
                    from: context
                ) {
                    throw DataRepositoryError.inputDataCorrupted(
                        error: .creation(name: "Такая сущность уже не существует \(summary.name)")
                    )
                }
            } catch {
                EventLogger.instance.reportError(error: error, onFailure: nil)
                throw DataRepositoryError.itemCorrupted(
                    name: summary.name,
                    error: error
                )
            }

            let categoryEntity: CategoryEntity = try CosmeticRepository.load(
                itemId: category.id,
                context
            )

            let detailEntity = ItemDetailEntity(context: context)
            detailEntity.id = detail.id
            let entityPhotos = detail.photos.map {
                let entity = PhotoEntity(context: context)
                entity.id = $0.id

                return entity
            }
            detailEntity.photos = NSSet(array: entityPhotos)
            CosmeticRepository.updateEntityDetail(detailEntity, with: detail)

            let summaryEntity = ItemSummaryEntity(context: context)
            summaryEntity.id = summary.id
            summaryEntity.category = categoryEntity
            summaryEntity.itemDetailId = detail.id
            summaryEntity.detail = detailEntity
            CosmeticRepository.updateSummaryDetail(summaryEntity, with: summary)
            categoryEntity.count += 1
        }
    }

    public func saveItem(
        from summary: ItemSummaryDTO,
        and detail: ItemDetailDTO,
        inCategory category: CategoryDTO
    ) async throws {

        guard summary.itemDetailId == detail.id,
              summary.categoryId == category.id
        else {
            assertionFailure("ID сущностей должны совпадать")
            throw DataRepositoryError.inputDataCorrupted(
                error: .mutation(name: "ID сущностей должны совпадать")
            )
        }

        try await persistentController.perform { context in
            let _: CategoryEntity = try CosmeticRepository.load(itemId: category.id, context)
            let summaryEntity: ItemSummaryEntity = try CosmeticRepository.load(
                itemId: summary.id,
                context
            )
            let detailEntity: ItemDetailEntity = try CosmeticRepository.load(
                itemId: detail.id,
                context
            )

            guard detailEntity.id != nil else {
                assertionFailure("У продукта \(detail.name) нет ID")
                throw DataRepositoryError.dataCorrupted(
                    name: detail.name,
                    error: nil,
                    subError: "У продукта нет ID"
                )
            }

            CosmeticRepository.updateEntityDetail(detailEntity, with: detail)

            let itemPhotos = detail.photos.map(\.id)
            let entityPhotos = detailEntity.photoArray.compactMap(\.id)

            if itemPhotos != entityPhotos {
                let itemPhotoSet = Set(itemPhotos)
                let entityPhotosSet = Set(entityPhotos)

                let photosToAppend = itemPhotoSet.subtracting(entityPhotosSet)
                let photosToDelete = entityPhotosSet.subtracting(itemPhotoSet)

                if !photosToDelete.isEmpty {
                    let photosSet = detailEntity.mutableSetValue(forKey: "photos")
                    let deletedPhotos = detailEntity.photoArray.filter { photo in
                        guard let id = photo.id else {
                            return false
                        }

                        return photosToDelete.contains(id)
                    }

                    for photo in deletedPhotos {
                        photosSet.remove(photo)
                        context.delete(photo)
                    }
                }

                if !photosToAppend.isEmpty {
                    let photosSet = detailEntity.mutableSetValue(forKey: "photos")
                    for id in photosToAppend {
                        let photo = PhotoEntity(context: context)
                        photo.id = id
                        photosSet.add(photo)
                    }
                }
            }

            CosmeticRepository.updateSummaryDetail(summaryEntity, with: summary)
        }
    }
}

private extension CosmeticRepository {

    static func load<Entity: NSManagedObject & IdentifiableEntity>(
        itemId: UUID,
        _ context: NSManagedObjectContext
    ) throws -> Entity {
        do {
            guard let entity: Entity = try CosmeticRepository.loadItem(
                byId: itemId,
                from: context
            ) else {
                throw DataRepositoryError.inputDataCorrupted(
                    error: .creation(name: "Такой сущности не существует \(itemId.uuidString)")
                )
            }

            return entity
        } catch {
            throw DataRepositoryError.itemCorrupted(
                name: itemId.uuidString,
                error: error
            )
        }
    }

    static func updateSummaryDetail(_ summaryEntity: ItemSummaryEntity, with summary: ItemSummaryDTO) {
        summaryEntity.name = summary.name
        summaryEntity.categoryId = summary.categoryId
        summaryEntity.openDate = summary.openDate
        summaryEntity.paoDate = summary.paoDate
        summaryEntity.photoId = summary.photo?.id
        summaryEntity.purchaseDate = summary.purchaseDate
        summaryEntity.expirationDate = summary.expirationDate
    }

    static func updateEntityDetail(_ detailEntity: ItemDetailEntity, with detail: ItemDetailDTO) {
        detailEntity.name = detail.name
        detailEntity.categoryId = detail.categoryId
        detailEntity.notes = detail.notes
        detailEntity.purchaseDate = detail.purchaseDate
        detailEntity.expirationDate = detail.expirationDate
        detailEntity.openDate = detail.openDate
        detailEntity.paoDate = detail.paoDate
    }
}

extension ItemDetailEntity {

    var photoArray: [PhotoEntity] {
        return (photos ?? []).compactMap { photo in
            guard let photoEntity = photo as? PhotoEntity else {
                return nil
            }
            return photoEntity
        }
    }
}
