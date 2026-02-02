//
//  CosmeticCategoriesView.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import SwiftUI
import DesignModule

struct CosmeticCategoriesView: View {

    @ObservedObject var viewModel: CosmeticCategoriesViewModel

    init(viewModel: CosmeticCategoriesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.backgroundColor(.view)
                .ignoresSafeArea()

            if viewModel.isLoading {
                CosmeticCategoriesSkeleton()
            } else {
                content()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadConfiguration()
            }
        }
    }
}

private extension CosmeticCategoriesView {

    @ViewBuilder
    func content() -> some View {
        VStack(spacing: .padding(.medium)) {
//            HStack(spacing: .padding(.medium)) {
//                CategoryCard(expirationStatus: .good)
//                CategoryCard(expirationStatus: .warning)
//                CategoryCard(expirationStatus: .expired)
//            }
//            .frame(maxWidth: .infinity)
//            HStack(spacing: .padding(.medium)) {
//                CategoryCard(expirationStatus: .expired)
//                CategoryCard(expirationStatus: .good)
//                CategoryCard(expirationStatus: .warning)
//            }
            CategoryItemCard(expirationStatus: .good)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .padding(.padding(.mediumLarge))
        }
    }
}
