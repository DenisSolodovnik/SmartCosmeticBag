//
//  CosmeticCoordinator.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

import SwiftUI
import CosmeticDataPool

@MainActor
public final class CosmeticCoordinator: ObservableObject {

    @Published public var path: [CosmeticScreens] = []

    private var cosmeticDataPool: CosmeticDataPool

    public init(cosmeticDataPool: CosmeticDataPool) {
        self.cosmeticDataPool = cosmeticDataPool
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
        CategoryItemsAssembly(categoryItemsDataPool: cosmeticDataPool).assembly()
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

