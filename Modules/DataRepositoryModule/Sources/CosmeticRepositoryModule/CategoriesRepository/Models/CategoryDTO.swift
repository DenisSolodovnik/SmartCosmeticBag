//
//  CategoryDTO.swift
//  DataPoolModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation

public struct CategoryDTO: Identifiable, Sendable {

    public let id: String
    let count: Int
    let name: String
    let photo: (id: String, kind: String)?
    let expirationDates: [Date]
}
