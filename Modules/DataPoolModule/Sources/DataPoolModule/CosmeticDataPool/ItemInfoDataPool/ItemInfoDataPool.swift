//
//  ItemInfoDataPool.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 09.01.2026.
//

public protocol IItemInfoDataPool: Sendable {

    func loadItem() async throws -> [ItemInfoDataModelDTO]
}

extension CosmeticDataPool: IItemInfoDataPool {

    public func loadItem() async throws -> [ItemInfoDataModelDTO] {
        []
    }
}
