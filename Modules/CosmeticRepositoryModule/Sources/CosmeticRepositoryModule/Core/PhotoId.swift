//
//  PhotoId.swift
//  CosmeticRepositoryModule
//
//  Created by Денис Солодовник on 26.05.2026.
//

import Foundation

public struct PhotoId: Equatable, Sendable {

    public let id: UUID
    public let categoryId: UUID

    public init(id: UUID, categoryId: UUID) {
        self.id = id
        self.categoryId = categoryId
    }
}
