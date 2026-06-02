//
//  MapItemsSummaryUseCase.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticRepositoryModule
import SwiftUI

struct MapItemsSummaryUseCase {

    func callAsFunction(_ items: [ItemSummaryDTO]) -> [SummaryItemModel] {
        var itemsArray: [SummaryItemModel] = []
        for item in items {
            itemsArray.append(
                SummaryItemModel(from: item)
            )
        }

        return itemsArray
    }
}
