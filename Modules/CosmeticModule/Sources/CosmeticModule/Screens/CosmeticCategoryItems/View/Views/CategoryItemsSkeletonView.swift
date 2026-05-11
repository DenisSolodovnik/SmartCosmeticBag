//
//  CategoryItemsSkeletonView.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import DesignModule

struct CategoryItemsSkeletonView: View {

    var body: some View {
        VStack {
            RoundedRectangle(cornerSize: .init(width: 12.0, height: 12.0))
                .frame(width: 200, height: 70)
                .skeleton()
        }
    }
}
