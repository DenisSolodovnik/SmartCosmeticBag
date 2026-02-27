//
//  ItemDetailDTO.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import Foundation

public struct ItemDetailDTO: Identifiable, Sendable {

    public let id: String
    let name: String
    let photos: [(id: String, kind: String)]
    let purchaseDate: Date
    let openDate: Date?
    let paoDate: Date?
    let expirationDate: Date
    let notes: String?

    public init(
        id: String,
        name: String,
        photos: [(id: String, kind: String)],
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
