import XCTest
@testable import LoggerModule

final class LoggerModuleTests: XCTestCase {

    func testCreateProduct() throws {
        let logger = EventLogger.instance
        let builder: EventPathBuilder = .init()
            .create()
            .category("Декоративная косметика")
            .product("Помада", numberOfImages: 3)

        let resultPath = builder.buildPath()
        let expectedPath = "create/category/product"
        XCTAssert(resultPath == expectedPath, "Both paths should be equal")
        logger.logEvent(
            builder: builder,
            onFailure: nil
        )
    }
}
