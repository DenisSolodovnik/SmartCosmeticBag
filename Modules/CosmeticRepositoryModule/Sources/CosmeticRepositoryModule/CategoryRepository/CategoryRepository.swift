//
//  CategoriesRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import LoggerModule

public protocol ICategoryRepository: Actor {

    func loadCategories() async throws -> [CategoryDTO]
    func createCategory(_ category: CategoryDTO) async throws
    func saveCategory(_ category: CategoryDTO) async throws
    func deleteCategory(_ category: CategoryDTO) async throws
}

extension CosmeticRepository: ICategoryRepository {

    public func loadCategories() async throws -> [CategoryDTO] {
        try await persistentController.perform { context in
            let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()

            let categories: [CategoryEntity]
            do {
                categories = try context.fetch(request)
            } catch {
                EventLogger.instance.reportError(error: error)
                assertionFailure("Не получилось загрузить категории")
                throw DataRepositoryError.categoriesCorrupted(category: nil, error: error)
            }

            return try categories.map { category in
                guard let id = category.id else {
                    assertionFailure("У категории отсутствует ID")
                    throw DataRepositoryError.dataCorrupted(
                        name: category.name,
                        error: nil,
                        subError: "У категории отсутствует ID"
                    )
                }

                let photo: (id: UUID, categoryId: UUID)?
                if let photoId = category.photoId {
                    photo = (id: photoId, categoryId: id)
                } else {
                    photo = nil
                }

                let dateArray = (category.expirationDates as? Set<ExpirationDateEntity>)?.compactMap(\.expirationDate) ?? []
                let items: [ItemSummaryDTO] = (category.items as? Set<ItemSummaryEntity>)?
                    .compactMap {
                        ItemSummaryDTO(from: $0)
                    } ?? []

                return .init(
                    id: id,
                    count: Int(category.count),
                    name: category.name ?? "",
                    photo: photo,
                    expirationDates: Set(dateArray),
                    items: Set(items)
                )
            }
        }
    }

    public func createCategory(_ category: CategoryDTO) async throws {
        try await persistentController.perform { context in
            do {
                if let _: CategoryEntity = try CosmeticRepository.loadItem(
                    byId: category.id,
                    from: context
                ) {
                    throw DataRepositoryError
                        .inputDataCorrupted(
                            error: .creation(name: "Такая категория уже существует \(category.name)")
                        )
                }
            } catch {
                EventLogger.instance.reportError(error: error)
                throw DataRepositoryError
                    .inputDataCorrupted(
                        error: .creation(name: "Такая категория уже существует \(category.name)")
                    )
            }

            let entity = CategoryEntity(context: context)
            entity.id = category.id
            entity.name = category.name
            entity.count = 0
            entity.photoId = category.photo?.id
        }
    }

    public func saveCategory(_ category: CategoryDTO) async throws {
        try await persistentController.perform { context in
            let entity: CategoryEntity
            do {
                if let categoryEntity: CategoryEntity = try CosmeticRepository.loadItem(
                    byId: category.id,
                    from: context
                ) {
                    entity = categoryEntity
                } else {
                    assertionFailure("Нужно сначала создать категорию \(category.name)")
                    throw DataRepositoryError.inputDataCorrupted(
                        error: .creation(name: "Нужно сначала создать категорию \(category.name)")
                    )
                }
            } catch {
                EventLogger.instance.reportError(error: error)
                assertionFailure("Не получилось загрузить категорию \(category.name)")
                throw DataRepositoryError.categoriesCorrupted(
                    category: category.name,
                    error: error
                )
            }

            entity.name = category.name
            entity.photoId = category.photo?.id
        }
    }

    public func deleteCategory(_ category: CategoryDTO) async throws {
        try await persistentController.perform { context in
            let entity: CategoryEntity
            do {
                if let existing: CategoryEntity = try CosmeticRepository.loadItem(
                    byId: category.id,
                    from: context
                ) {
                    entity = existing
                } else {
                    return
                }
            } catch {
                EventLogger.instance.reportError(error: error)
                assertionFailure("Не получилось загрузить категорию \(category.name)")
                throw DataRepositoryError.categoriesCorrupted(category: category.name, error: error)
            }

            context.delete(entity)
        }
    }
}
