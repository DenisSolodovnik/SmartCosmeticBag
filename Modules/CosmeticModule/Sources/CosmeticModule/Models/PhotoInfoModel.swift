//
//  PhotoInfoModel.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 26.02.2026.
//

import Foundation
import PhotoStorage

struct PhotoInfoModel {

    let id: UUID
    let categoryId: UUID

    init(id: UUID, categoryId: UUID) {
        self.id = id
        self.categoryId = categoryId
    }

    func getPhotoKey() -> PhotoKey {
        .init(id: id, categoryId: categoryId)
    }
}
