//
//  MapPoolItemsUseCase.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticDataPool
import SwiftUI

struct MapPoolItemsUseCase {

    func callAsFunction(_ items: [CategoryItemDataModelDTO]) -> [CategoryItemModel] {
        var itemsArr: [CategoryItemModel] = []
        for _ in items {
            itemsArr.append(
                CategoryItemModel(
                    id: 0,
                    name: "",
                    photo: .init(uiImage: .add),
                    expirationDate: Date(),
                    paoDate: Date(),
                    purchaseDate: Date()
                )
            )
        }

        return itemsArr
    }
}
