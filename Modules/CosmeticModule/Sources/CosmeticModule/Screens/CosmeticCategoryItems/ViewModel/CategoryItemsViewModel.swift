//
//  CategoryItemsViewModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import Foundation
import CoreData
import CosmeticRepositoryModule
import PhotoStorage
import UIKit

@MainActor final class CategoryItemsViewModel: ObservableObject {

    @Published var isLoading: Bool = true

    var itemSortKey: CategoryItemSortKey = .bestBefore
    var isAscending: Bool = true

    private let itemsRepository: ICategoryItemsRepository
    let photoStorage: IPhotoStorage

    private let mapPoolItems: MapCategoryItemsUseCase
    private let sortItems: SortItemsUseCase

    @Published var itemModels: [CategoryItemModel] = []

    init(
        itemsRepository: ICategoryItemsRepository,
        photoStorage: IPhotoStorage
    ) {
        self.itemsRepository = itemsRepository
        self.photoStorage = photoStorage

        mapPoolItems = .init()
        sortItems = .init()
    }

    func loadItemModels() async {
        guard isLoading else { return }

        itemModels.append(
            contentsOf: [
                .init(id: UUID(), categoryId: UUID(),
                      name: "Name1 Name1 Name1 Name1 Name1 Name1 Name1 Name1 Name1 Name1 Name1 Name1",
                      photo: .init(id: UUID(), categoryId: UUID()),
                      expirationDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                      purchaseDate: Date()),
                .init(id: UUID(), categoryId: UUID(),
                      name: "Name2",
                      photo: .init(id: UUID(), categoryId: UUID()),
                      expirationDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                      purchaseDate: Date()),
                .init(id: UUID(), categoryId: UUID(),
                      name: "Name3",
                      photo: .init(id: UUID(), categoryId: UUID()),
                      expirationDate: Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(),
                      purchaseDate: Date())
            ]
        )

        itemModels = sortItems(itemModels, by: .name, order: .orderedAscending)

        isLoading = false
    }

    func deleteModel(id: UUID) {
        if let index = itemModels.firstIndex(where: { $0.id == id }) {
            itemModels.remove(at: index)
        }
    }
}

