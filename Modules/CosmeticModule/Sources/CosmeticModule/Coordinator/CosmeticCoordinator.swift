//
//  CosmeticCoordinator.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

import SwiftUI

@MainActor
public final class CosmeticCoordinator: ObservableObject {

    public static let shared = CosmeticCoordinator()

    @Published public var path: [CosmeticScreens] = []

    private init() {}

    // MARK: - View Factory

    @ViewBuilder
    public func build(_ route: CosmeticScreens) -> some View {
        switch route {
            case .categoriesList:
                CosmeticCategoriesAssembly().assembly()
                //                CosmeticCategoriesView(
                //                    onCategoryTap: { [weak self] id in
                //                        self?.push(.category(id: id))
                //                    }
                //                )

            case .createCategory:
                EmptyView()

            case .categoryItems:
                EmptyView()

            case .addCategoryItem:
                EmptyView()

            case .categoryItemView:
                EmptyView()
        }
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
