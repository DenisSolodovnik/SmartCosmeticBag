//
//  CosmeticCategoriesView.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import SwiftUI

struct CosmeticCategoriesView: View {

    @ObservedObject var viewModel: CosmeticCategoriesViewModel

    init(viewModel: CosmeticCategoriesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color(.simpleBackground)
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
        VStack {
            RoundedRectangle(cornerSize: .init(width: 12.0, height: 12.0))
                .foregroundStyle(Color.orange)
                .frame(width: 200, height: 70)
        }
    }
}
