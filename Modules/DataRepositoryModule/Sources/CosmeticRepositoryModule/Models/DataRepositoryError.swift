//
//  DataRepositoryError.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import Foundation

public enum DataRepositoryError: Error, Sendable {

    case categoriesNotFound(Error?)
    case categoryItemsNotFound(category: String, error: Error?)
    case itemNotFound(id: String, error: Error?)
    case dataCorrupted(name: String?, error: Error?)

    var errorDescription: String {
        switch self {
            case .categoriesNotFound:
                "Не найдено категорий!"
            case let .categoryItemsNotFound(category, _):
                "Не найдено продуктов в категории \(category)!"
            case let .itemNotFound(id, _):
                "Не найден продукт id, название \(id)"
            case let .dataCorrupted(name, _):
                "Данные повреждены, имя: \(name ?? "")"
        }
    }
}
