//
//  CategoryItemModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticRepositoryModule
import SwiftUI

struct CategoryItemModel: Identifiable {

    let id: String
    let name: String
    private(set) var photoInfo: PhotoInfoModel?
    let expirationDate: Date
    let paoDate: Date?
    let purchaseDate: Date

    init(from dto: CategoryItemDTO) {
        id = dto.id
        name = dto.name
        expirationDate = dto.expirationDate
        paoDate = dto.paoDate
        purchaseDate = dto.purchaseDate

        photoInfo = if let photo = dto.photo, let kind = PhotoKind(rawValue: photo.kind) {
            .init(id: photo.id, kind: kind)
        } else {
            nil
        }
    }
}

extension CategoryItemModel {
    
    var expirationDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: expirationDate)
    }

    var paoDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        guard let paoDate else {
            return "Средство не было открыто."
        }

        return dateFormatter.string(from: paoDate)
    }

    var purchaseDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: purchaseDate)
    }

    var bestBeforeDate: Date {
        min(expirationDate, paoDate ?? Date())
    }

    var bestBeforeDateString: String {
        let expireDate = min(expirationDate, paoDate ?? expirationDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.string(from: expireDate)
    }
}
