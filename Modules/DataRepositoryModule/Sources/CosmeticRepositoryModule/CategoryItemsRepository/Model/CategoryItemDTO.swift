//
//  CategoryItemDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import SwiftUI

public struct CategoryItemDTO: Identifiable, Sendable {

    public let id: String
    public let name: String
    public let photo: (id: String, kind: String)?
    public let purchaseDate: Date
    public let paoDate: Date?
    public let expirationDate: Date

    public init(
        id: String,
        name: String,
        photoId: String?,
        photoKind: String?,
        purchaseDate: Date,
        paoDate: Date?,
        expirationDate: Date
    ) {
        self.id = id
        self.name = name
        self.expirationDate = expirationDate
        self.paoDate = paoDate
        self.purchaseDate = purchaseDate

        guard let photoId, let photoKind else {
            photo = nil
            return
        }
        
        self.photo = (id: photoId, kind: photoKind)
    }
}
