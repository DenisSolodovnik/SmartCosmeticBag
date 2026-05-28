import XCTest
@testable import CosmeticRepositoryModule

final class CategoryEntityTests: XCTestCase {

    func testDeleteAll() async throws {
        let repository = CosmeticRepository(inMemory: true)
        try await repository.resetAllData()

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testNoCategoryLoad() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")
    }

    func testCategoryCreate() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let category = CategoryDTO(
            id: UUID(),
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )

        try await repository.createCategory(category)

        var categories = try await repository.loadCategories()
        XCTAssert(categories.count == 1, "Categories should be empty")

        try await repository.deleteCategory(category)
        categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testDeleteCategory() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let category = CategoryDTO(
            id: UUID(),
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )

        try await repository.createCategory(category)

        var categories = try await repository.loadCategories()
        XCTAssert(categories.count == 1, "Categories should be empty")

        try await repository.deleteCategory(category)
        categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testSameCategoriesCreate() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let categoryId: UUID = UUID()
        let category = CategoryDTO(
            id: categoryId,
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )
        let category2 = CategoryDTO(
            id: categoryId,
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )

        try await repository.createCategory(category)

        do {
            try await repository.createCategory(category2)
        } catch let error as DataRepositoryError {
            switch error {
                case let .inputDataCorrupted(error):
                    switch error {
                        case .creation:
                            break

                        default:
                            XCTFail("Error type is not expected")
                    }

                default:
                    XCTFail("Error type is not expected")
            }
        }

        var categories = try await repository.loadCategories()
        XCTAssert(categories.count == 1, "Categories should be empty")

        try await repository.deleteCategory(category)
        categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testDifferentCategoriesCreate() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let category = CategoryDTO(
            id: UUID(),
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )
        let category2 = CategoryDTO(
            id: UUID(),
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )

        try await repository.createCategory(category)
        try await repository.createCategory(category2)

        var categories = try await repository.loadCategories()
        XCTAssert(categories.count == 2, "Categories should be empty")

        try await repository.deleteCategory(category)
        try await repository.deleteCategory(category2)
        categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testCategoryItemsLoad() async throws {
        let repository = CosmeticRepository(inMemory: true)
        let category = CategoryDTO(
            id: UUID(),
            count: 0,
            name: "Помада",
            photo: nil,
            expirationDates: [],
            items: []
        )

        try await repository.createCategory(category)

        var categories = try await repository.loadCategories()
        guard let category = categories.first else {
            XCTFail("Category should be saved")
            return
        }

        XCTAssert(category.expirationDates.isEmpty, "Expiration dates should be empty")

        try await repository.deleteCategory(category)
        categories = try await repository.loadCategories()

        XCTAssert(categories.isEmpty, "Categories should be empty")

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }

    func testDeleteCategoryWithItems() async throws {
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


        var dtos = try await repository.loadItems(by: category)

        var categories = try await repository.loadCategories()
        let dto = categories.first { $0.id == category.id }
        XCTAssert(dto?.count == 2, "Should be 2 items")
        XCTAssert(dto?.items.count == 2, "Should be 2 items")

        try await repository.deleteCategory(category)

        categories = try await repository.loadCategories()
        guard let category = categories.first else {
            XCTAssert(categories.isEmpty, "Categories should be empty")
            return
        }

        dtos = try await repository.loadItems(by: category)
        XCTAssert(dtos.isEmpty, "Items should be empty")

        dtos = try await repository.loadItems(byIds: items.map(\.id))
        XCTAssert(dtos.isEmpty, "Items should be empty")

        XCTAssert(category.items.count == 2, "Should be 2 items")

        try await repository.deleteCategory(category)

        let isDBEmpty = try await repository.isDatabaseEmpty()
        XCTAssert(isDBEmpty, "DB should be empty")
    }
}
