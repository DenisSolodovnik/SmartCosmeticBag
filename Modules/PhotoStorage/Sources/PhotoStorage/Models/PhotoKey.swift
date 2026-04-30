//
//  PhotoKey.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 27.02.2026.
//

import Foundation

public struct PhotoKey: Hashable, Sendable {

    private let id: String
    let categoryId: String
    let cacheKey: String

    public init(id: UUID, categoryId: UUID) {
        self.id = id.uuidString
        self.categoryId = categoryId.uuidString

        cacheKey = "\(categoryId)_\(id.uuidString)"
    }

    func fileURL(_ baseFolderURL: URL) -> URL {
        baseFolderURL
            .appendingPathComponent(categoryId)
            .appendingPathComponent(id, isDirectory: false)
            .appendingPathExtension("dat")
    }
}
