import XCTest
@testable import CosmeticModule
@testable import CosmeticDataPool

final class CosmeticModuleTests: XCTestCase {

    @MainActor func testZeroCount() async throws {
        final class NoItemsDataPool: ICategoryItemsDataPool {
            func loadItems() async throws -> [CategoryItemDataModelDTO] {
                []
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsDataPool: NoItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadItemsThrows() async throws {
        final class ThrowItemsDataPool: ICategoryItemsDataPool {
            func loadItems() async throws -> [CategoryItemDataModelDTO] {
                throw NSError(
                    domain: "DigitalMjollnir.SmartCosmeticBug.CategoryItems",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Throws test"]
                )
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsDataPool: ThrowItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadThreeItems() async throws {
        final class ThreeItemsDataPool: ICategoryItemsDataPool {
            func loadItems() async throws -> [CategoryItemDataModelDTO] {
                [
                    CategoryItemDataModelDTO(id: 0, purchaseDate: Date()),
                    CategoryItemDataModelDTO(id: 0, purchaseDate: Date()),
                    CategoryItemDataModelDTO(id: 0, purchaseDate: Date())
                ]
            }
        }

        let model: CategoryItemsViewModel = .init(categoryItemsDataPool: ThreeItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 3)
    }
}
