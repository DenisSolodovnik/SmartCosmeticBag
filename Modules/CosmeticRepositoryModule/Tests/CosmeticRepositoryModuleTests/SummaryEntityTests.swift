//
//  SummaryEntityTests.swift
//  CosmeticRepositoryModule
//
//  Created by Денис Солодовник on 25.05.2026.
//

import XCTest
@testable import CosmeticRepositoryModule

final class SummaryEntityTests: XCTestCase {

    func testCreateSameSummary() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categoryId = UUID()
        let itemSummaryId = UUID()
        let detailID1 = UUID()
        let detailID2 = UUID()
        let category = CategoryDTO.dummy(id: categoryId, name: "Помада")
        let details: [ItemDetailDTO] = [
            ItemDetailDTO.dummy(id: detailID1, categoryId: categoryId, name: "Name1"),
            ItemDetailDTO.dummy(id: detailID2, categoryId: categoryId, name: "Name2")
        ]
        let summary: [ItemSummaryDTO] = [
            ItemSummaryDTO.dummy(id: itemSummaryId, itemDetailId: detailID1, categoryId: categoryId, name: "Name1"),
            ItemSummaryDTO.dummy(id: itemSummaryId, itemDetailId: detailID2, categoryId: categoryId, name: "Name2")
        ]

        try await repository.createCategory(category)
        try await repository.createItem(from: summary[0], and: details[0], inCategory: category)

        do {
            try await repository.createItem(from: summary[1], and: details[1], inCategory: category)
        } catch let error as DataRepositoryError {
            print("error: \(error)")
            switch error {
                case .itemCorrupted:
                    break

                default:
                    print("error: \(error)")
                    XCTFail("Error should be .inputDataCorrupted")
            }
        }

        let loadedSummary = try await repository.loadItems(by: category)
        XCTAssert(loadedSummary.count == 1, "Count should be equal 2")
    }

    func testCreateDifferentSummary() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categoryId = UUID()
        let detailID1 = UUID()
        let detailID2 = UUID()
        let category = CategoryDTO.dummy(id: categoryId, name: "Помада")
        let details: [ItemDetailDTO] = [
            ItemDetailDTO.dummy(id: detailID1, categoryId: categoryId, name: "Name1"),
            ItemDetailDTO.dummy(id: detailID2, categoryId: categoryId, name: "Name2")
        ]
        let items: [ItemSummaryDTO] = [
            ItemSummaryDTO.dummy(itemDetailId: detailID1, categoryId: categoryId, name: "Name1"),
            ItemSummaryDTO.dummy(itemDetailId: detailID2, categoryId: categoryId, name: "Name2")
        ]

        try await repository.createCategory(category)
        try await repository.createItem(from: items[0], and: details[0], inCategory: category)
        try await repository.createItem(from: items[1], and: details[1], inCategory: category)

        let summary = try await repository.loadItems(by: category)
        XCTAssert(summary.count == 2, "Count should be equal 2")
        XCTAssert(items == summary, "Loaded items should be equal to created")
    }

    func testDeleteSummary() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categoryId = UUID()
        let detailID1 = UUID()
        let detailID2 = UUID()
        let category = CategoryDTO.dummy(id: categoryId, name: "Помада")
        let details: [ItemDetailDTO] = [
            ItemDetailDTO.dummy(id: detailID1, categoryId: categoryId, name: "Name1"),
            ItemDetailDTO.dummy(id: detailID2, categoryId: categoryId, name: "Name2")
        ]
        let items: [ItemSummaryDTO] = [
            ItemSummaryDTO.dummy(itemDetailId: detailID1, categoryId: categoryId, name: "Name1"),
            ItemSummaryDTO.dummy(itemDetailId: detailID2, categoryId: categoryId, name: "Name2")
        ]

        try await repository.createCategory(category)
        try await repository.createItem(from: items[0], and: details[0], inCategory: category)
        try await repository.createItem(from: items[1], and: details[1], inCategory: category)

        try await repository.deleteItems(items, inCategory: category)

        let loadedItems = try await repository.loadItems(by: category)
        XCTAssert(loadedItems.isEmpty, "LoadedItems should be empty")

        let loadedCategory = try await repository.loadCategories().first!
        XCTAssert(loadedCategory.count == 0, "Items should be empty")
        XCTAssert(loadedCategory.items.count == 0, "Items should be empty")
    }
}
