//
//  ItemsSummaryAssembly.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import CosmeticRepositoryModule
import PhotoStorage

public struct ItemsSummaryAssembly {

    @MainActor public func assembly(
        itemsRepository: IItemSummaryRepository,
        photoStorage: any IPhotoStorage
    ) -> some View {
        let viewModel = ItemsSummaryViewModel(
            itemsRepository: itemsRepository,
            photoStorage: photoStorage
        )

        return ItemsSummaryView(viewModel: viewModel)
    }
}
