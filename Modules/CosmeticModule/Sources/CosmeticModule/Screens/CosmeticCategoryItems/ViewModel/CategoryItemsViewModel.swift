//
//  CategoryItemsViewModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import Foundation
import CoreData
import CosmeticRepositoryModule

@MainActor
final class CategoryItemsViewModel: ObservableObject {

    @Published var isLoading: Bool = true

    var categoryItemSortKey: CategoryItemSortKey = .bestBefore
    var isAscending: Bool = true

    private let categoryItemsRepository: ICategoryItemsRepository

    private let mapPoolItems: MapCategoryItemsUseCase
    private let sortItems: SortItemsUseCase

    @Published var itemModels: [CategoryItemModel] = []

    init(categoryItemsRepository: ICategoryItemsRepository) {
        self.categoryItemsRepository = categoryItemsRepository

        mapPoolItems = .init()
        sortItems = .init()
    }

    func loadItemModels() async {
        guard isLoading else { return }

        // TODO: add loading items

        isLoading = false
    }

    func deleteModel(id: String) {
        if let index = itemModels.firstIndex(where: { $0.id == id }) {
            itemModels.remove(at: index)
        }
    }
}

