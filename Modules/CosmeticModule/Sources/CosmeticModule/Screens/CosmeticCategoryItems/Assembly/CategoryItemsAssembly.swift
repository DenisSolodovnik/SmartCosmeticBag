//
//  CategoryItemsAssembly.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import CosmeticDataPool

public struct CategoryItemsAssembly {

    private let categoryItemsDataPool: ICategoryItemsDataPool

    public init(categoryItemsDataPool: ICategoryItemsDataPool) {
        self.categoryItemsDataPool = categoryItemsDataPool
    }

    @MainActor public func assembly() -> some View {
        let viewModel = CategoryItemsViewModel(categoryItemsDataPool: categoryItemsDataPool)

        return CategoryItemsView(viewModel: viewModel)
    }
}
