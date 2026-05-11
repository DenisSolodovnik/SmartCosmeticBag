//
//  SortItemsUseCase.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticRepositoryModule
import SwiftUI

struct SortItemsUseCase {

    enum ComparisonOrder {

        case orderedAscending
        case orderedDescending
    }

    func callAsFunction(
        _ items: [CategoryItemModel],
        by key: CategoryItemSortKey,
        order: ComparisonOrder
    ) -> [CategoryItemModel] {

        switch key {
            case .bestBefore: getSorted(by: \.bestBeforeDate, order: order, items: items)
            case .purchaseDate: getSorted(by: \.purchaseDate, order: order, items: items)
            case .name: getSorted(by: \.nameForSort, order: order, items: items)
        }
    }

    private func getSorted(
        by property: KeyPath<CategoryItemModel, some Comparable>,
        order: ComparisonOrder,
        items: [CategoryItemModel],
        postfix: String = ""
    ) -> [CategoryItemModel] {

        if order == .orderedAscending {
            items.sorted { (lhs, rhs) -> Bool in lhs[keyPath: property] < rhs[keyPath: property] }
        } else {
            items.sorted { (lhs, rhs) -> Bool in lhs[keyPath: property] > rhs[keyPath: property] }
        }
    }
}

private extension CategoryItemModel {

    var nameForSort: String {
        "\(name)\(id.uuidString)"
    }
}
