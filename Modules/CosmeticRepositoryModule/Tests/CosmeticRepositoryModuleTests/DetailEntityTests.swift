//
//  DetailEntityTests.swift
//  CosmeticRepositoryModule
//
//  Created by Денис Солодовник on 25.05.2026.
//

import XCTest
@testable import CosmeticRepositoryModule

final class DetailEntityTests: XCTestCase {

    func testCreateDetail() async throws {
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

        let detail1 = try await repository.loadItem(of: items[0])
        let detail2 = try await repository.loadItem(of: items[1])
        let loadedDetails = [detail1, detail2]

        XCTAssert(loadedDetails == details, "Loaded items should be equal to created")
    }

    func testDeleteDetail() async throws {
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

        try await repository.deleteItem(items[0])
        try await repository.deleteItem(items[1])

        do {
            let _ = try await repository.loadItem(of: items[0])
        } catch let error as DataRepositoryError {
            switch error {
                case .itemCorrupted:
                    break
                default:
                    XCTFail("Error should be .itemCorrupted")
            }
        }

        do {
            let _ = try await repository.loadItem(of: items[1])
        } catch let error as DataRepositoryError {
            switch error {
                case .itemCorrupted:
                    break
                default:
                    XCTFail("Error should be .itemCorrupted")
            }
        }
    }

    func testDetailPhotoChange() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categoryId = UUID()
        let detailID1 = UUID()
        let photos1: [PhotoId] = [
            .init(id: UUID(), categoryId: categoryId),
            .init(id: UUID(), categoryId: categoryId),
            .init(id: UUID(), categoryId: categoryId)
        ]
        let photos2: [PhotoId] = [
            .init(id: UUID(), categoryId: categoryId),
            .init(id: photos1[1].id, categoryId: categoryId),
            .init(id: photos1[2].id, categoryId: categoryId)
        ]
        let category = CategoryDTO.dummy(id: categoryId, name: "Помада")
        let detail = ItemDetailDTO.dummy(
            id: detailID1,
            categoryId: categoryId,
            name: "Name1",
            photos: photos1
        )
        let summary = ItemSummaryDTO.dummy(
            itemDetailId: detailID1,
            categoryId: categoryId,
            name: "Name1"
        )

        try await repository.createCategory(category)
        try await repository.createItem(from: summary, and: detail, inCategory: category)

        let detail1 = try await repository.loadItem(of: summary)
        XCTAssert(detail1.photos.sorted(by: <) == photos1.sorted(by: <), "Photos should be equal")

        var detail2 = ItemDetailDTO.dummy(
            id: detail1.id,
            categoryId: detail1.categoryId,
            name: detail1.name,
            photos: photos2
        )
        try await repository.saveItem(from: summary, and: detail2, inCategory: category)
        detail2 = try await repository.loadItem(of: summary)
        XCTAssert(detail2.photos.sorted(by: <) == photos2.sorted(by: <), "Photos should be equal")
    }
}
