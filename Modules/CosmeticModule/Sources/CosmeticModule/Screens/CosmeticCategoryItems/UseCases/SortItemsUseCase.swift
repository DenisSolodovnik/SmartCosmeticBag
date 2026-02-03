//
//  SortItemsUseCase.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import CosmeticDataPool

struct SortItemsUseCase {

    func callAsFunction(
        _ items: [CategoryItemModel],
        by key: CategoryItemSortKey,
        isAscending: Bool
    ) -> [CategoryItemModel] {

        switch key {
            case .bestBefore:
                if isAscending {
                    items.sorted { $0.bestBeforeDate < $1.bestBeforeDate }
                } else {
                    items.sorted { $0.bestBeforeDate > $1.bestBeforeDate }
                }
            case .purchaseDate:
                if isAscending {
                    items.sorted { $0.purchaseDate < $1.purchaseDate }
                } else {
                    items.sorted { $0.purchaseDate > $1.purchaseDate }
                }
            case .name:
                if isAscending {
                    items.sorted { $0.name + String($0.id) < $1.name + String($1.id) }
                } else {
                    items.sorted { $0.name + String($0.id) > $1.name + String($1.id) }
                }
        }
    }
}
