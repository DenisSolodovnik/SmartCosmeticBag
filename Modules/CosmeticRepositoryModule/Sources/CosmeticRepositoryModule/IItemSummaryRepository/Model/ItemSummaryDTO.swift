//
//  CategoryItemDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation

public struct ItemSummaryDTO: Identifiable, Hashable, Equatable, Sendable {

    public let id: UUID
    public let itemDetailId: UUID
    public let categoryId: UUID
    public let name: String
    public let photo: PhotoId?
    public let purchaseDate: Date
    public let openDate: Date?
    public let paoDate: Date?
    public let expirationDate: Date

    init?(from entity: ItemSummaryEntity) {
        guard let id = entity.id,
              let categoryId = entity.categoryId,
              let itemDetailId = entity.itemDetailId,
              let name = entity.name,
              let purchaseDate = entity.purchaseDate,
              let expirationDate = entity.expirationDate else {
            return nil
        }

        self.id = id
        self.itemDetailId = itemDetailId
        self.categoryId = categoryId
        self.name = name
        self.purchaseDate = purchaseDate
        self.openDate = entity.openDate
        self.paoDate = entity.paoDate
        self.expirationDate = expirationDate

        if let photoId = entity.photoId {
            self.photo = .init(id: photoId, categoryId: categoryId)
        } else {
            self.photo = nil
        }
    }

    public init(
        id: UUID,
        itemDetailId: UUID,
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
        self.itemDetailId = itemDetailId

        guard let photoId else {
            photo = nil
            return
        }
        
        self.photo = .init(id: photoId, categoryId: categoryId)
    }

    public static func ==(lhs: ItemSummaryDTO, rhs: ItemSummaryDTO) -> Bool {
        lhs.id == rhs.id
        && lhs.categoryId == rhs.categoryId
        && lhs.name == rhs.name
        && lhs.photo?.id == rhs.photo?.id
        && lhs.photo?.categoryId == rhs.photo?.categoryId
        && lhs.purchaseDate == rhs.purchaseDate
        && lhs.openDate == rhs.openDate
        && lhs.paoDate == rhs.paoDate
        && lhs.expirationDate == rhs.expirationDate
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static let errorInstance: Self = {
        .init(
            id: .init(),
            itemDetailId: UUID(),
            categoryId: .init(),
            name: "Error",
            photoId: nil,
            purchaseDate: .init(),
            openDate: nil,
            paoDate: nil,
            expirationDate: .init()
        )
    }()
}
