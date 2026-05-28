//
//  Extensions.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 24.05.2026.
//

import CosmeticRepositoryModule
import Foundation

extension CategoryDTO {

    static func dummy(id: UUID = UUID(), name: String = "Name") -> CategoryDTO {
        .init(
            id: id,
            count: 0,
            name: name,
            photo: nil,
            expirationDates: [],
            items: []
        )
    }
}

extension ItemSummaryDTO {

    static func dummy(
        id: UUID = UUID(),
        itemDetailId: UUID = UUID(),
        categoryId: UUID = UUID(),
        name: String = "Name"
    ) -> ItemSummaryDTO {
        .init(
            id: id,
            itemDetailId: itemDetailId,
            categoryId: categoryId,
            name: "Name1",
            photoId: nil,
            purchaseDate: Date(),
            openDate: nil,
            paoDate: nil,
            expirationDate: Date()
        )
    }
}

extension ItemDetailDTO {

    static func dummy(
        id: UUID = UUID(),
        categoryId: UUID = UUID(),
        name: String = "Name"
    ) -> ItemDetailDTO {
        .init(
            id: id,
            categoryId: categoryId,
            name: name,
            photos: [],
            expirationDate: Date(),
            paoDate: nil,
            purchaseDate: Date(),
            openDate: nil,
            notes: nil
        )
    }
}
