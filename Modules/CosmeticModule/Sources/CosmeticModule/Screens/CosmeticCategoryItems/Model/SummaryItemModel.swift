//
//  SummaryItemModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import CosmeticRepositoryModule

struct SummaryItemModel: Identifiable {

    let id: UUID
    let itemDetailId: UUID
    let categoryId: UUID
    let name: String
    let photoInfo: PhotoInfoModel?
    let expirationDate: Date
    let paoDate: Date?
    let purchaseDate: Date
    let openDate: Date?

    let expirationDateString: String
    let paoDateString: String
    let openDateString: String
    let purchaseDateString: String

    let bestBeforeDate: Date
    let bestBeforeDateString: String
    let daysToExpiration: String

    private let dto: ItemSummaryDTO

    init(from dto: ItemSummaryDTO) {
        self.init(from: dto, customPhoto: nil)
    }

    private init(from dto: ItemSummaryDTO, customPhoto: PhotoInfoModel?) {
        self.dto = dto
        id = dto.id
        itemDetailId = dto.itemDetailId
        categoryId = dto.categoryId
        name = dto.name
        expirationDate = dto.expirationDate
        paoDate = dto.paoDate
        purchaseDate = dto.purchaseDate
        openDate = dto.openDate

        if let customPhoto {
            photoInfo = customPhoto
        } else if let photo = dto.photo {
            photoInfo = PhotoInfoModel(id: photo.id, categoryId: categoryId)
        } else {
            photoInfo = nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        if let paoDate = dto.paoDate {
            paoDateString = dateFormatter.string(from: paoDate)
        } else {
            paoDateString = "Не открыто."
        }

        if let openDate = dto.openDate {
            openDateString = dateFormatter.string(from: openDate)
        } else {
            openDateString = "Не открыто."
        }

        expirationDateString = dateFormatter.string(from: expirationDate)
        purchaseDateString = dateFormatter.string(from: purchaseDate)
        bestBeforeDate = min(expirationDate, paoDate ?? Date.distantFuture)
        bestBeforeDateString = dateFormatter.string(from: bestBeforeDate)

        let daysCount = Calendar.current.dateComponents([.day], from: Date(), to: bestBeforeDate).day
        daysToExpiration = "\(daysCount ?? 0) дней"
    }

#if DEBUG
    init(
        id: UUID,
        itemDetailId: UUID,
        categoryId: UUID,
        name: String,
        photo info: PhotoInfoModel?,
        expirationDate: Date,
        purchaseDate: Date
    ) {
        self.id = id
        self.itemDetailId = itemDetailId
        self.name = name
        self.categoryId = categoryId
        self.photoInfo = info
        self.expirationDate = expirationDate
        self.purchaseDate = purchaseDate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        expirationDateString = dateFormatter.string(from: expirationDate)
        purchaseDateString = dateFormatter.string(from: purchaseDate)
        bestBeforeDate = expirationDate
        bestBeforeDateString = dateFormatter.string(from: bestBeforeDate)

        paoDate = nil
        openDate = nil
        paoDateString = "Не открыто."
        openDateString = "Не открыто."

        let daysCount = Calendar.current.dateComponents([.day], from: Date(), to: bestBeforeDate).day ?? 0
        daysToExpiration = "\(daysCount) дней"

        dto = .init(
            id: id,
            itemDetailId: itemDetailId,
            categoryId: categoryId,
            name: name,
            photoId: photoInfo?.id,
            purchaseDate: purchaseDate,
            openDate: openDate,
            paoDate: paoDate,
            expirationDate: expirationDate
        )
    }
#endif // DEBUG

    func addingPhoto(_ photo: PhotoInfoModel) -> Self {
        .init(from: dto, customPhoto: photo)
    }

    func updateDates() -> Self {
        .init(from: dto, customPhoto: nil)
    }
}
