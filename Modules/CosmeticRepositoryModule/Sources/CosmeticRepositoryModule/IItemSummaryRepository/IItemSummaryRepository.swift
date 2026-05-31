//
//  ItemsSummaryRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import Foundation

public protocol IItemSummaryRepository: Actor {

    func loadItems(by category: CategoryDTO) async throws -> [ItemSummaryDTO]
    func loadItems(byIds ids: [UUID]) async throws -> [ItemSummaryDTO]
    func deleteItem(_ item: ItemSummaryDTO) async throws
    func deleteItems(_ items: [ItemSummaryDTO], inCategory category: CategoryDTO) async throws

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

extension CosmeticRepository: IItemSummaryRepository {

    public func loadItems(by category: CategoryDTO) async throws -> [ItemSummaryDTO] {
        try await persistentController.perform { context in
            let request: NSFetchRequest<ItemSummaryEntity> = ItemSummaryEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category.id == %@", category.id as CVarArg)

            let items: [ItemSummaryEntity]
            do {
                items = try context.fetch(request)
            } catch {
                assertionFailure("Такой категории не существует \(category.name)")
                throw DataRepositoryError.categoryItemsCorrupted(category: category.name, error: error)
            }

            return items.compactMap { (item) -> ItemSummaryDTO? in
                guard item.id != nil,
                      item.category?.id != nil else {
                    assertionFailure("Отсутствует идентификатор товара\(item.name, default: "")")
                    return nil
                }

                return .init(from: item)
            }
        }
    }

    public func loadItems(byIds ids: [UUID]) async throws -> [ItemSummaryDTO] {
        try await persistentController.perform { context in
            let items: [ItemSummaryEntity]
            do {
                items = try CosmeticRepository.loadItems(byIds: ids, from: context)
            } catch {
                assertionFailure("Таких продуктов не существует \(ids)")
                throw DataRepositoryError.inputDataCorrupted(
                    error: .existence(name: "Таких продуктов не существует \(ids)")
                )
            }

            if items.isEmpty {
                assertionFailure("Таких продуктов не существует \(ids)")
                throw DataRepositoryError.inputDataCorrupted(
                    error: .existence(name: "Таких продуктов не существует \(ids)")
                )
            }

            return items.compactMap { (item) -> ItemSummaryDTO? in
                guard item.id != nil,
                      item.category?.id != nil else {
                    assertionFailure("Отсутствует идентификатор товара\(item.name, default: "")")
                    return nil
                }

                return .init(from: item)
            }
        }
    }

    public func deleteItem(_ summary: ItemSummaryDTO) async throws {
        try await persistentController.perform { context in
            guard let entity: ItemSummaryEntity = try? CosmeticRepository.loadItem(
                byId: summary.id,
                from: context
            ) else {
                return
            }

            if let category: CategoryEntity = try? CosmeticRepository.loadItem(
                byId: summary.categoryId,
                from: context
            ) {
                category.count = max(0, category.count - 1)
            }

            context.delete(entity)
        }
    }

    public func deleteItems(
        _ items: [ItemSummaryDTO],
        inCategory category: CategoryDTO
    ) async throws {

        let categoryId = category.id
        guard !items.isEmpty else {
            assertionFailure("Массив продуктов не должен быть пустым")
            throw DataRepositoryError.inputDataCorrupted(
                error: .equality(name: "Массив продуктов не должен быть пустым")
            )
        }
        guard items.allSatisfy({ $0.categoryId == categoryId }) else {
            assertionFailure("ID продуктов не совпадают с ID категории \(categoryId)")
            throw DataRepositoryError.inputDataCorrupted(
                error: .equality(name: "ID продуктов не совпадают с ID категории \(categoryId)")
            )
        }

        try await persistentController.perform { context in
            let ids = items.map(\.id)
            guard let entities: [ItemSummaryEntity] = try? CosmeticRepository.loadItems(byIds: ids, from: context) else {
                return
            }

            if let existingCategory: CategoryEntity = try? CosmeticRepository.loadItem(
                byId: categoryId,
                from: context
            ) {
                existingCategory.count = max(0, existingCategory.count - Int64(entities.count))
            }

            let fetchItemsDelete = NSFetchRequest<NSFetchRequestResult>(
                entityName: "ItemSummaryEntity"
            )
            fetchItemsDelete.predicate = NSPredicate(format: "id IN %@", ids)
            let deleteItemsRequest = NSBatchDeleteRequest(fetchRequest: fetchItemsDelete)
            deleteItemsRequest.resultType = .resultTypeObjectIDs

            let itemsResult = try context.execute(deleteItemsRequest) as? NSBatchDeleteResult
            if let deletedObjectIDs = itemsResult?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: deletedObjectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        }
    }
}
