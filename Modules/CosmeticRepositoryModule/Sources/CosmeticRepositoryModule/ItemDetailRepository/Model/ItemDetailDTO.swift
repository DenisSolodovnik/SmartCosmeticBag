//
//  ItemDetailDTO.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import Foundation

public struct ItemDetailDTO: Identifiable, Equatable, Sendable {

    public let id: UUID
    public let categoryId: UUID
    let name: String
    let photos: [PhotoId]
    let purchaseDate: Date
    let openDate: Date?
    let paoDate: Date?
    let expirationDate: Date
    let notes: String?

    init?(from entity: ItemDetailEntity) {
        guard let id = entity.id,
              let categoryId = entity.categoryId,
              let name = entity.name,
              let purchaseDate = entity.purchaseDate,
              let expirationDate = entity.expirationDate else {
            return nil
        }

        self.id = id
        self.categoryId = categoryId
        self.name = name
        self.purchaseDate = purchaseDate
        self.openDate = entity.openDate
        self.paoDate = entity.paoDate
        self.expirationDate = expirationDate
        self.notes = entity.notes

        let photos = entity.photoArray.compactMap(\.id)
        if !photos.isEmpty {
            self.photos = photos.map { .init(id: $0, categoryId: categoryId) }
        } else {
            self.photos = []
        }
    }

    public init(
        id: UUID,
        categoryId: UUID,
        name: String,
        photos: [PhotoId],
        expirationDate: Date,
        paoDate: Date?,
        purchaseDate: Date,
        openDate: Date?,
        notes: String?
    ) {
        self.id = id
        self.categoryId = categoryId
        self.name = name
        self.photos = photos
        self.expirationDate = expirationDate
        self.paoDate = paoDate
        self.purchaseDate = purchaseDate
        self.openDate = openDate
        self.notes = notes
    }
}
