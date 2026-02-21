//
//  MapCategoryItemsUseCase.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticRepositoryModule
import SwiftUI

struct MapCategoryItemsUseCase {

    func callAsFunction(_ items: [CategoryItemDTO]) -> [CategoryItemModel] {
        var itemsArray: [CategoryItemModel] = []
        for item in items {
            itemsArray.append(
                CategoryItemModel(from: item)
            )
        }

        return itemsArray
    }
}
