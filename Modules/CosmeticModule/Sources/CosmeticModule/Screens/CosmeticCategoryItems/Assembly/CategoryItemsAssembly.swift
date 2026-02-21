//
//  CategoryItemsAssembly.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import CosmeticRepositoryModule

public struct CategoryItemsAssembly {

    private let categoryItemsRepository: ICategoryItemsRepository

    public init(categoryItemsRepository: ICategoryItemsRepository) {
        self.categoryItemsRepository = categoryItemsRepository
    }

    @MainActor public func assembly() -> some View {
        let viewModel = CategoryItemsViewModel(categoryItemsRepository: categoryItemsRepository)

        return CategoryItemsView(viewModel: viewModel)
    }
}
