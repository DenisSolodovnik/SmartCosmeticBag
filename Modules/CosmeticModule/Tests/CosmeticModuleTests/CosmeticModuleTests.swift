import XCTest
@testable import CosmeticModule
@testable import CosmeticRepositoryModule

final class CosmeticModuleTests: XCTestCase {

    @MainActor func testZeroCount() async throws {
        final class NoItemsDataPool: ICategoryItemsRepository {
            func loadItems(by category: String, itemsPerPage: Int) async throws -> [CategoryItemDTO] {
                []
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsRepository: NoItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadItemsThrows() async throws {
        final class ThrowItemsDataPool: ICategoryItemsRepository {
            func loadItems(by category: String, itemsPerPage: Int) async throws -> [CategoryItemDTO] {
                throw DataRepositoryError.categoryItemsNotFound(category: "Throws test", error: nil)
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsRepository: ThrowItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadThreeItems() async throws {
        final class ThreeItemsDataPool: ICategoryItemsRepository {
            func loadItems(by category: String, itemsPerPage: Int) async throws -> [CategoryItemDTO] {
                [
                    CategoryItemDTO.empty(),
                    CategoryItemDTO.empty(),
                    CategoryItemDTO.empty()
                ]
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsRepository: ThreeItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 3)
    }
}

private extension CategoryItemDTO {

    static func empty() -> Self {
        .init(
            id: "",
            name: "",
            photo: nil,
            expirationDate: Date(),
            paoDate: nil,
            purchaseDate: Date()
        )
    }
}
