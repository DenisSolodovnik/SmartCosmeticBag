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
    let expirationDates: [Date]
}
