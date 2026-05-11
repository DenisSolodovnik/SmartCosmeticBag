//
//  CategoryItemsAssembly.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import CosmeticRepositoryModule
import PhotoStorage

public struct CategoryItemsAssembly {

    @MainActor public func assembly(
        itemsRepository: ICategoryItemsRepository,
        photoStorage: any IPhotoStorage
    ) -> some View {
        let viewModel = CategoryItemsViewModel(
            itemsRepository: itemsRepository,
            photoStorage: photoStorage
        )

        return CategoryItemsView(viewModel: viewModel)
    }
}
