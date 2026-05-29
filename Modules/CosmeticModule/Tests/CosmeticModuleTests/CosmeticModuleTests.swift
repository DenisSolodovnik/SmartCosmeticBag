import XCTest
@testable import CosmeticModule
import CosmeticRepositoryModule
import PhotoStorage

final class CosmeticModuleTests: XCTestCase {

    @MainActor func testZeroCount() async throws {
        let storage = try PhotoStorage()
        let model: ItemsSummaryViewModel = .init(
            itemsRepository: NoItemsDataPool(),
            photoStorage: storage
        )

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadItemsThrows() async throws {
        let storage = try PhotoStorage()
        let model: ItemsSummaryViewModel = .init(
            itemsRepository: ThrowItemsDataPool(),
            photoStorage: storage
        )

        await model.loadItemModels()
        XCTAssertEqual(model.itemModels.count, 0)
    }

    @MainActor func testLoadThreeItems() async throws {
    }
}
