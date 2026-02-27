//
//  CategoriesRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData
import CoreRepositoryModule

public protocol ICategoriesRepository: Sendable {

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

            return categories.map { category in
                let photo: (id: String, kind: String)?
                if let photoId = category.photoId, let photoKind = category.photoKind {
                    photo = (id: photoId, kind: photoKind)
                } else {
                    photo = nil
                }

                return .init(
                    id: category.id ?? "",
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
