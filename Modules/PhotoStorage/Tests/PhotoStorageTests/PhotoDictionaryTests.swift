//
//  PhotoDictionaryTests.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 11.05.2026.
//


import XCTest
@testable import PhotoStorage

final class PhotoDictionaryTests: XCTestCase {

    func testDictionary() async {
        let dict = PhotoIdDictionary()
        let storage = await dict.dictionaryStorage

        XCTAssert(storage.isEmpty, "Dictionary should be empty")
    }

    func testSaveEqual() async {
        let dict = PhotoIdDictionary()
        let key = PhotoKey(id: UUID(), categoryId: UUID())
        let task1: Task<Void, Error> = Task { () }
        let task2: Task<Void, Error> = Task { () }

        await dict.insert(.empty(task1), forKey: key, and: .load)
        await dict.insert(.empty(task2), forKey: key, and: .load)

        let storage = await dict.dictionaryStorage
        XCTAssert(storage.count == 1, "Dictionary should be equal 1")

        guard let result = storage[key]?[.load] else {
            XCTFail("Dictionary value shouldn't be nil")
            return
        }


        switch result {
            case let .empty(task):
                XCTAssert(task != task1, "Dictionary task should be equal to latest task")
                XCTAssert(task == task2, "Dictionary task should be equal to latest task")

            default:
                XCTFail("Tasks should have with same operations")
        }
    }

    func testSaveDifferentOperations() async {
        let dict = PhotoIdDictionary()
        let key = PhotoKey(id: UUID(), categoryId: UUID())

        await dict.insert(.empty(Task {}), forKey: key, and: .load)
        await dict.insert(.empty(Task {}), forKey: key, and: .save)

        let storage = await dict.dictionaryStorage
        XCTAssert(storage[key]?.count == 2, "Dictionary should be equal 2")
    }

    func testValues() async {
        let dict = PhotoIdDictionary()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: UUID())
        ]
        let tasks: [TaskResult] = [
            .empty(Task {}),
            .data(Task { Data() }),
            .empty(Task {})
        ]
        let operations: [FileOperation] = [
            .delete,
            .load,
            .save
        ]

        for index in 0..<photoKeys.count {
            await dict.insert(
                tasks[index],
                forKey: photoKeys[index],
                and: operations[index]
            )
        }

        for index in 0..<photoKeys.count {
            let value = await dict.value(forKey: photoKeys[index], and: operations[index])
            XCTAssert(
                value == tasks[index],
                "Tasks should be equal for some FileOperation type"
            )
        }
    }

    func testDeleteValues() async {
        let dict = PhotoIdDictionary()
        let categoryId = UUID()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: categoryId),
            PhotoKey(id: UUID(), categoryId: categoryId)
        ]
        let operations: [FileOperation] = [
            .load,
            .load,
            .save
        ]

        for index in 0..<photoKeys.count {
            await dict.insert(
                .empty(Task {}),
                forKey: photoKeys[index],
                and: operations[index]
            )
        }

        await dict.removeValues(forKeys: [photoKeys[0], photoKeys[1]], and: .load)

        let storage = await dict.dictionaryStorage
        XCTAssert(
            storage.count == 1,
            "There should be only one value. values == \(storage.count)"
        )
    }

    func testDeletAllValues() async {
        let dict = PhotoIdDictionary()
        let categoryId = UUID()
        let photoKeys: [PhotoKey] = [
            PhotoKey(id: UUID(), categoryId: UUID()),
            PhotoKey(id: UUID(), categoryId: categoryId),
            PhotoKey(id: UUID(), categoryId: categoryId)
        ]
        let operations: [FileOperation] = [
            .load,
            .load,
            .save
        ]

        for index in 0..<photoKeys.count {
            await dict.insert(
                .empty(Task {}),
                forKey: photoKeys[index],
                and: operations[index]
            )
        }

        await dict.removeAllValues()
        let storage = await dict.dictionaryStorage
        XCTAssert(storage.isEmpty, "Storage should be empty")
    }
}
