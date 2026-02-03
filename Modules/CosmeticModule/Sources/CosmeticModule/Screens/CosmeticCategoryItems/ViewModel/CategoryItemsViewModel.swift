//
//  CategoryItemsViewModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import Foundation
import AppConfigurationModule
import CosmeticDataPool

@MainActor
final class CategoryItemsViewModel: ObservableObject {

    @Published var isLoading: Bool = true

    var categoryItemSortKey: CategoryItemSortKey = .bestBefore
    var isAscending: Bool = true

    private let categoryItemsDataPool: ICategoryItemsDataPool

    private let mapPoolItems: MapPoolItemsUseCase
    private let sortItems: SortItemsUseCase

    @Published var itemModels: [CategoryItemModel] = []

    init(categoryItemsDataPool: ICategoryItemsDataPool) {
        self.categoryItemsDataPool = categoryItemsDataPool

        mapPoolItems = .init()
        sortItems = .init()
    }

    func loadItemModels() async {
        guard isLoading else { return }

        do {
            let dtoItems = try await categoryItemsDataPool.loadItems()
            let mappedItems = mapPoolItems(dtoItems)
            itemModels = sortItems(mappedItems, by: categoryItemSortKey, isAscending: isAscending)
        } catch {
            itemModels = []
        }

        isLoading = false
    }

    func deleteModel(id: Int) {
        if let index = itemModels.firstIndex(where: { $0.id == id }) {
            itemModels.remove(at: index)
        }

        // Add Core data save!
    }
}

