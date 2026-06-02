//
//  ItemsSummaryView.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import SwiftUI
import DesignModule
import PhotoStorage
import os

struct ItemsSummaryView: View {

    @ObservedObject var viewModel: ItemsSummaryViewModel
    @State private var isLoading: Bool = true

    init(viewModel: ItemsSummaryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        let _ = Self._printChanges()

        return ZStack {
            Color.backgroundColor(.view)
                .ignoresSafeArea()

            if viewModel.isLoading {
                ItemsSummarySkeletonView()
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

private extension ItemsSummaryView {

    @ViewBuilder
    func content() -> some View {
        LazyVStack(spacing: .padding(.medium)) {
            ForEach(viewModel.itemModels) { model in
                CategoryItem(
                    photoStorage: viewModel.photoStorage,
                    itemModel: model
                )
                .frame(maxWidth: .infinity)
                .padding(.padding(.medium))
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

struct CategoryItem: View {

    let key: PhotoKey?
    let photoStorage: IPhotoStorage
    let itemModel: SummaryItemModel

    @State private var image: UIImage?

    init(photoStorage: IPhotoStorage, itemModel: SummaryItemModel) {
        self.key = itemModel.photoInfo?.getPhotoKey()
        self.photoStorage = photoStorage
        self.itemModel = itemModel
    }

    var body: some View {
        RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard))
            .foregroundStyle(Color.backgroundColor(.card))
            .frame(height: 128)
            .overlay {
                HStack(spacing: .padding(.medium)) {
                    imageItem()
                        .frame(width: 64, height: 64)

                    VStack(alignment: .leading, spacing: .padding(.medium)) {
                        Text(itemModel.name)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                        Text(itemModel.expirationDateString)
                        Text(itemModel.paoDateString)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, .padding(.small))

                    VStack(alignment: .trailing, spacing: .padding(.small)) {
                        Spacer()
                        HStack(spacing: .padding(.extraSmall)) {
                            Text("Истекает")
                            Image(systemName: "arrow.2.circlepath.circle")
                        }
                        .frame(alignment: .trailing)
                        Text("через \(itemModel.daysToExpiration)")
                    }
                    .frame(alignment: .bottom)
                    .padding(.bottom, .padding(.medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.padding(.medium))
            }
            .overlay {
                RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard))
                    .stroke(style: .init(lineWidth: 1, lineCap: .round))
                    .foregroundStyle(Color.strokeColor(.card))
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard)))
            .glow(.card)
            .task(id: key) {
                guard let photoKey = key, image == nil else {
                    return
                }

                image = try? await photoStorage.getPhoto(for: photoKey)
            }
    }

    @ViewBuilder
    func imageItem() -> some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard)))
        } else {
            Image(systemName: "arrow.2.circlepath.circle")
                .resizable()
        }
    }

    func releaseData() {
        image = nil
    }
}
