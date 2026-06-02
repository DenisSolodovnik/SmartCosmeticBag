//
//  CosmeticCoordinator.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

import CosmeticRepositoryModule
import LoggerModule
import PhotoStorage
import SwiftUI

@MainActor
public final class CosmeticCoordinator: ObservableObject {

    @Published public var path: [CosmeticScreens] = []

    private let cosmeticRepository: CosmeticRepository
    private let photoStorage: IPhotoStorage

    public init(
        cosmeticRepository: CosmeticRepository,
        photoStorage: IPhotoStorage
    ) {
        self.cosmeticRepository = cosmeticRepository
        self.photoStorage = photoStorage
    }

    // MARK: - View Factory

    @ViewBuilder
    public func build(_ route: CosmeticScreens) -> some View {
        switch route {
            case .categoriesList:
                categoryItemsScreen()
                //                CosmeticCategoriesView(
                //                    onCategoryTap: { [weak self] id in
                //                        self?.push(.category(id: id))
                //                    }
                //                )

            case .createCategory:
                EmptyView()

            case .itemsSummary:
                categoryItemsScreen()

            case .addItem:
                EmptyView()

            case .itemSummaryView:
                EmptyView()
        }
    }
}

// MARK: - Screens

private extension CosmeticCoordinator {

    func categoryItemsScreen() -> some View {
        ItemsSummaryAssembly().assembly(
            itemsRepository: cosmeticRepository,
            photoStorage: photoStorage
        )
    }
}

// MARK: - Navigation API

private extension CosmeticCoordinator {

    func push(_ route: CosmeticScreens) {
        withAnimation {
            path.append(route)
        }
    }

    func pop() {
        guard !path.isEmpty else { return }

        withAnimation {
            _ = path.removeLast()
        }
    }

    func popToRoot() {
        path = [.categoriesList]
    }
}

