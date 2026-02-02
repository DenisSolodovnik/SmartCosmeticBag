//
//  CategoryItemsDataPool.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

import Foundation

public protocol ICategoryItemsDataPool: Sendable {

    func loadItems() async throws -> [CategoryItemDataModelDTO]
}

extension CosmeticDataPool: ICategoryItemsDataPool {

    public func loadItems() async throws -> [CategoryItemDataModelDTO] {
        return [CategoryItemDataModelDTO(id: 0, purchaseDate: Date())]
    }
}
