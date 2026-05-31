//
//  NoItemsDataPool.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 28.05.2026.
//

import CosmeticRepositoryModule
import Foundation

final actor NoItemsDataPool: IItemSummaryRepository {
    func loadItems(byIds ids: [UUID]) async throws -> [ItemSummaryDTO] {
        []
    }
    
    func deleteItem(_ item: ItemSummaryDTO) async throws {
    }
    
    func deleteItems(_ items: [ItemSummaryDTO], inCategory category: CategoryDTO) async throws {
    }
    
    func createItem(from summary: ItemSummaryDTO, and detail: ItemDetailDTO, inCategory category: CategoryDTO) async throws {
    }
    
    func saveItem(from summary: ItemSummaryDTO, and detail: ItemDetailDTO, inCategory category: CategoryDTO) async throws {
    }
    
    func loadItems(by category: CategoryDTO) async throws -> [ItemSummaryDTO] {
        []
    }
}
