//
//  PhotoIdDictionary.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 03.05.2026.
//

import Foundation

enum FileOperation: String, CaseIterable {

    case load
    case save
    case delete
}

enum TaskResult: Equatable {

    case data(Task<Data, Error>)
    case empty(Task<Void, Error>)

    static func ==(lhs: TaskResult, rhs: TaskResult) -> Bool {
        switch (lhs, rhs) {
            case let (.data(value1), .data(value2)): value1 == value2
            case (.empty, .empty): true
            default: false
        }
    }
}

final actor PhotoIdDictionary {

    private var storage: [PhotoKey: [FileOperation: TaskResult]]

    init() {
        storage = [:]
    }

    init(storage: [PhotoKey: [FileOperation: TaskResult]]) {
        self.storage = storage
    }

    func insert(
        _ value: TaskResult,
        forKey key: PhotoKey,
        and operation: FileOperation,
    ) {
        storage[key, default: [:]][operation] = value
    }

    func value(forKey key: PhotoKey, and operation: FileOperation) -> TaskResult? {
        storage[key]?[operation]
    }

    func removeValue(forKey key: PhotoKey, and operation: FileOperation) {
        storage[key]?[operation] = nil
        if storage[key]?.isEmpty == true {
            storage[key] = nil
        }
    }

    func removeValues(forKeys keys: [PhotoKey], and operation: FileOperation) {
        for key in keys {
            removeValue(forKey: key, and: operation)
        }
    }

    func removeAllValues(keepingCapacity: Bool = false) {
        storage.removeAll(keepingCapacity: keepingCapacity)
    }
}

#if DEBUG

extension PhotoIdDictionary {

    var dictionaryStorage: [PhotoKey: [FileOperation: TaskResult]] {
        storage
    }
}

#endif
