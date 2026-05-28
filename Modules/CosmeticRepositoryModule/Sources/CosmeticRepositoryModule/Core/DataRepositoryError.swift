//
//  DataRepositoryError.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import Foundation

public enum DataRepositoryError: Error, Sendable {

    public enum InputDataError: Sendable {

        case creation(name: String)
        case existence(name: String)
        case mutation(name: String)
        case equality(name: String)
    }

    case categoriesCorrupted(category: String?, error: Error?)
    case categoryItemsCorrupted(category: String, error: Error?)
    case itemCorrupted(name: String, error: Error?)
    case dataCorrupted(name: String?, error: Error?, subError: String?)
    case inputDataCorrupted(error: InputDataError)
    case saveError(Error)

    var errorDescription: String {
        switch self {
            case let .categoriesCorrupted(name, _):
                "Не получилось загрузить категорию \(name, default: "\r")!"

            case let .categoryItemsCorrupted(category, _):
                "Не получилось загрузить продукты из категории \(category)!"

            case let .itemCorrupted(name, _):
                "Не получилось загрузить продукт. \(name)"

            case let .dataCorrupted(name, _, subError):
                "Данные повреждены, имя: \(name, default: "")\n\(subError, default: "\r")"

            case .inputDataCorrupted:
                "Некорректные данные ввода"

            case .saveError:
                "Ошибка сохранения"
        }
    }
}
