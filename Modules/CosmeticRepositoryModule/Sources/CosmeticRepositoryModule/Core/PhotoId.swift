//
//  PhotoId.swift
//  CosmeticRepositoryModule
//
//  Created by Денис Солодовник on 26.05.2026.
//

import Foundation

public struct PhotoId: Equatable, Comparable, Sendable {

    public let id: UUID
    public let categoryId: UUID

    public init(id: UUID, categoryId: UUID) {
        self.id = id
        self.categoryId = categoryId
    }

    public static func < (lhs: PhotoId, rhs: PhotoId) -> Bool {
        if lhs.categoryId == rhs.categoryId {
            return lhs.id < rhs.id
        }

        return lhs.id < rhs.id && lhs.categoryId < rhs.categoryId
    }
}
