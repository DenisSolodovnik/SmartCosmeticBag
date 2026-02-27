//
//  CategoryItemsView.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import SwiftUI
import DesignModule

struct CategoryItemsView: View {

    @ObservedObject var viewModel: CategoryItemsViewModel

    init(viewModel: CategoryItemsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.backgroundColor(.view)
                .ignoresSafeArea()

            if viewModel.isLoading {
                CategoryItemsSkeletonView()
            } else {
                content()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadItemModels()
            }
        }
    }
}

private extension CategoryItemsView {

    @ViewBuilder
    func content() -> some View {
        VStack(spacing: .padding(.medium)) {
            ForEach(viewModel.itemModels) { model in
                CategoryItemCard(
                    expirationStatus: .good,
                    itemPhoto: viewModel.getPhoto(from: model),
                    expirationDate: model.expirationDateString,
                    paoDate: model.paoDateString
                )
                .frame(maxWidth: .infinity)
                .padding(.padding(.mediumLarge))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteModel(id: model.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}
