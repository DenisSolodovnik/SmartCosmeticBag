import XCTest
@testable import CosmeticModule

final class CosmeticModuleTests: XCTestCase {

    @MainActor func testZeroCount() async throws {
        let model: ItemsSummaryViewModel = .init(categoryItemsRepository: NoItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadItemsThrows() async throws {
        let model: ItemsSummaryViewModel = .init(categoryItemsRepository: ThrowItemsDataPool())

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadThreeItems() async throws {
    }
}
