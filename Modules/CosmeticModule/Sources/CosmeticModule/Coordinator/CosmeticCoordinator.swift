//
//  CosmeticCoordinator.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

import SwiftUI
import CosmeticRepositoryModule

@MainActor
public final class CosmeticCoordinator: ObservableObject {

    @Published public var path: [CosmeticScreens] = []

    private var cosmeticRepository: CosmeticRepository

    public init(cosmeticRepository: CosmeticRepository) {
        self.cosmeticRepository = cosmeticRepository
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

            case .categoryItems:
                categoryItemsScreen()

            case .addCategoryItem:
                EmptyView()

            case .categoryItemView:
                EmptyView()
        }
    }
}

// MARK: - Screens

private extension CosmeticCoordinator {

    func categoryItemsScreen() -> some View {
        CategoryItemsAssembly(categoryItemsRepository: cosmeticRepository).assembly()
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

