//
//  CategoryDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation

public struct CategoryDTO: Identifiable, Sendable {

    public let id: UUID
    let count: Int
    let name: String
    let photo: (id: UUID, categoryId: UUID)?
    let expirationDates: Set<Date>
    let items: Set<ItemSummaryDTO>

    public init?(from entity: CategoryEntity) {
        guard let id = entity.id,
              let name = entity.name,
              let items = entity.items
        else { return nil }

        self.id = id
        self.count = Int(entity.count)
        self.name = name
        self.photo = nil
        self.expirationDates = []
        self.items = Set(items.compactMap { $0 as? ItemSummaryDTO })
    }

    public init(
        id: UUID,
        count: Int,
        name: String,
        photo: (id: UUID, categoryId: UUID)?,
        expirationDates: Set<Date>,
        items: Set<ItemSummaryDTO>
    ) {
        self.id = id
        self.count = count
        self.name = name
        self.photo = photo
        self.expirationDates = expirationDates
        self.items = items
    }
}
