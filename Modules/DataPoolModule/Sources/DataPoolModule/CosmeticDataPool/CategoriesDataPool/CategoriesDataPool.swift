//
//  CategoriesDataPool.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

public protocol ICategoriesDataPool: Sendable {

    func loadCategories() async throws -> [CategoryDataModelDTO]
}

extension CosmeticDataPool: ICategoriesDataPool {

    public func loadCategories() async throws -> [CategoryDataModelDTO] {
        []
    }
}
