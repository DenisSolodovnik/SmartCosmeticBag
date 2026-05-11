//
//  ItemDetailDTO.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import Foundation

public struct ItemDetailDTO: Identifiable, Sendable {

    public let id: UUID
    let name: String
    let photos: [(id: UUID, categoryId: UUID)]
    let purchaseDate: Date
    let openDate: Date?
    let paoDate: Date?
    let expirationDate: Date
    let notes: String?

    public init(
        id: UUID,
        name: String,
        photos: [(id: UUID, categoryId: UUID)],
        expirationDate: Date,
        paoDate: Date,
        purchaseDate: Date,
        openDate: Date?,
        notes: String?
    ) {
        self.id = id
        self.name = name
        self.photos = photos
        self.expirationDate = expirationDate
        self.paoDate = paoDate
        self.purchaseDate = purchaseDate
        self.openDate = openDate
        self.notes = notes
    }
}
