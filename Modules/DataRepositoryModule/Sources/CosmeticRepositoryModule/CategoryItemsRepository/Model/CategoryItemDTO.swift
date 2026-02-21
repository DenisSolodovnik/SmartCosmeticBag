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
    public let photo: String?
    public let expirationDate: Date
    public let paoDate: Date?
    public let purchaseDate: Date

    public init(
        id: String,
        name: String,
        photo: String?,
        expirationDate: Date,
        paoDate: Date?,
        purchaseDate: Date
    ) {
        self.id = id
        self.name = name
        self.photo = photo
        self.expirationDate = expirationDate
        self.paoDate = paoDate
        self.purchaseDate = purchaseDate
    }
}
