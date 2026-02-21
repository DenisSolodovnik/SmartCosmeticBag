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

            return categories.map {
                .init(
                    id: $0.id ?? "",
                    count: Int($0.count),
                    name: $0.name ?? "",
                    categoryPhoto: $0.categoryPhoto?.photoPath,
                    expirationDates: (
                        $0.expirationDates as? Set<ExpirationDateEntity>
                    )?.compactMap(\.expirationDate) ?? []
                )
            }
        }
    }
}
