//
//  DataRepositoryError.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

public enum DataRepositoryError: Error, Sendable {

    case categoriesNotFound(Error?)
    case categoryItemsNotFound(category: String, error: Error?)
    case itemNotFound(category: String, item: String, error: Error?)

    var localizedDescription: String {
        switch self {
            case .categoriesNotFound:
                "Не найдено категорий!"
            case let .categoryItemsNotFound(category, _):
                "Не найдено продуктов в категории \(category)!"
            case let .itemNotFound(category, item, _):
                "Не найден продукт категории: \(category), название \(item)"
        }
    }
}
