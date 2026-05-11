//
//  CategoryItemDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation

public struct CategoryItemDTO: Identifiable, Sendable {

    public let id: UUID
    public let categoryId: UUID
    public let name: String
    public let photo: (id: UUID, categoryId: UUID)?
    public let purchaseDate: Date
    public let openDate: Date?
    public let paoDate: Date?
    public let expirationDate: Date

    public init(
        id: UUID,
        categoryId: UUID,
        name: String,
        photoId: UUID?,
        purchaseDate: Date,
        openDate: Date?,
        paoDate: Date?,
        expirationDate: Date
    ) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.expirationDate = expirationDate
        self.paoDate = paoDate
        self.purchaseDate = purchaseDate
        self.openDate = openDate

        guard let photoId else {
            photo = nil
            return
        }
        
        self.photo = (id: photoId, categoryId: categoryId)
    }
}
