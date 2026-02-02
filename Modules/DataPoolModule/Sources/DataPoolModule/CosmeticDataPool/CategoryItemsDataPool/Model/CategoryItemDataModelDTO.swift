//
//  CategoryItemDataModelDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation

public final class CategoryItemDataModelDTO: Identifiable {

    public let id: Int
    public let purchaseDate: Date

    public init(id: Int, purchaseDate: Date) {
        self.id = id
        self.purchaseDate = purchaseDate
    }
}
