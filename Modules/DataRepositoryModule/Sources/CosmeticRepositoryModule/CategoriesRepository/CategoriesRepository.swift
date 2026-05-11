//
//  CategoriesRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import CoreRepositoryModule

public protocol ICategoriesRepository: Actor {

    func loadCategories() async throws -> [CategoryDTO]
}

extension CosmeticRepository: ICategoriesRepository {

    public func loadCategories() async throws -> [CategoryDTO] {
        try await persistentController.perform { context in
            let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()

            let categories: [CategoryEntity]
            do {
                categories = try context.fetch(request)
            } catch {
                throw DataRepositoryError.categoriesNotFound(error)
            }

            return try categories.map { category in
                guard let id = category.id else {
                    throw DataRepositoryError.dataCorrupted(name: category.name, error: nil)
                }

                let photo: (id: UUID, categoryId: UUID)?
                if let photoId = category.photoId {
                    photo = (id: photoId, categoryId: id)
                } else {
                    photo = nil
                }

                return .init(
                    id: id,
                    count: Int(category.count),
                    name: category.name ?? "",
                    photo: photo,
                    expirationDates: (
                        category.expirationDates as? Set<ExpirationDateEntity>
                    )?.compactMap(\.expirationDate) ?? []
                )
            }
        }
    }
}
