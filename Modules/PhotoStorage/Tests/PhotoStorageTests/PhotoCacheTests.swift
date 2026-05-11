//
//  PhotoCacheTests.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 09.05.2026.
//


import XCTest
@testable import PhotoStorage

final class PhotoCacheTests: XCTestCase {

    func testCache() async {
        let cache = PhotoCache()
        let keys = await cache.getKeys()
        let innerCache = await cache.getAllCache()

        XCTAssert(keys.isEmpty, "Keys should be empty!")
        XCTAssert(innerCache.isEmpty, "Cache should be empty!")
    }

    func testSave() async throws {
        let cache = PhotoCache()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID())
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.count == 3, "Keys shouldn't be empty!")
        XCTAssert(innerCache.count == 3, "Cache shouldn't be empty!")
    }

    func testLoad() async throws {
        let cache = PhotoCache()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID())
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)

        let datas: [Data?] = try await withThrowingTaskGroup(of: Data?.self) { group in
            for key in photoKeys {
                group.addTask {
                    await PhotoCacheTests.loadData(forKey: key, to: cache)
                }
            }

            var collected: [Data?] = []
            for try await result in group {
                collected.append(result)
            }
            return collected
        }

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.count == 3, "Keys should't be empty!")
        XCTAssert(innerCache.count == 3, "Cache should't be empty!")

        for object in datas {
            guard let object else {
                XCTFail("Loaded object shouldn't be equal to nil")
                continue
            }

            XCTAssert(object == data, "Saved and loaded objects should be equal")
        }
    }

    func testDeleteObject() async throws {
        let cache = PhotoCache()
        let categoryID = UUID()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: categoryID),
            PhotoKey(id: UUID(), categoryId: categoryID)
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)

        await cache.removeObject(forKey: photoKeys[1])

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.count == 2, "Keys count should be equal 2")
        XCTAssert(innerCache.count == 2, "Cache should be equal 2")
    }

    func testDeleteObjects() async throws {
        let cache = PhotoCache()
        let categoryID = UUID()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: categoryID),
            PhotoKey(id: UUID(), categoryId: categoryID)
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)
        await cache.removeObjects(forKeys: [photoKeys[0], photoKeys[2]])

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.count == 1, "Keys count should be equal 1")
        XCTAssert(innerCache.count == 1, "Cache should be equal 1")
    }

    func testDeleteObjectsInCategory() async throws {
        let cache = PhotoCache()
        let categoryID = UUID()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: categoryID),
            PhotoKey(id: UUID(), categoryId: categoryID)
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)
        await cache.removeAllObjects(forCategoryId: categoryID)

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.count == 1, "Keys count should be equal 1")
        XCTAssert(innerCache.count == 1, "ache should be equal 1")
    }

    func testDeleteAllObjects() async throws {
        let cache = PhotoCache()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID())
        ]

        let data = Data(count: 1024)
        let objects = photoKeys.map { (data, $0) }
        try await cache.setObjects(objects)
        await cache.removeAllObjects()

        let keys = await cache.getKeys()
        let innerCache = await cache.getCache(forKeys: photoKeys)

        XCTAssert(keys.isEmpty, "Keys should be empty!")
        XCTAssert(innerCache.isEmpty, "Cache should be empty!")
    }

    private static func saveData(
        _ object: Data,
        forKey key: PhotoKey,
        to cache: IPhotoCache
    ) async {
        await cache.setObject(object, forKey: key)
    }

    private static func loadData(
        forKey key: PhotoKey,
        to cache: IPhotoCache
    ) async -> Data? {
        await cache.object(forKey: key)
    }
}

