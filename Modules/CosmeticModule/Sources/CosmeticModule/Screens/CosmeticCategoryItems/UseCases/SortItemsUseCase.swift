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
        _ items: [SummaryItemModel],
        by key: SummaryItemSortKey,
        order: ComparisonOrder
    ) -> [SummaryItemModel] {

        switch key {
            case .bestBefore: getSorted(by: \.bestBeforeDate, order: order, items: items)
            case .purchaseDate: getSorted(by: \.purchaseDate, order: order, items: items)
            case .name: getSorted(by: \.nameForSort, order: order, items: items)
        }
    }

    private func getSorted(
        by property: KeyPath<SummaryItemModel, some Comparable>,
        order: ComparisonOrder,
        items: [SummaryItemModel],
        postfix: String = ""
    ) -> [SummaryItemModel] {

        if order == .orderedAscending {
            items.sorted { (lhs, rhs) -> Bool in lhs[keyPath: property] < rhs[keyPath: property] }
        } else {
            items.sorted { (lhs, rhs) -> Bool in lhs[keyPath: property] > rhs[keyPath: property] }
        }
    }
}

private extension SummaryItemModel {

    var nameForSort: String {
        "\(name)\(id.uuidString)"
    }
}
