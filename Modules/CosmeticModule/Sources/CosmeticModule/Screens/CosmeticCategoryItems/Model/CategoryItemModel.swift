//
//  CategoryItemModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 01.02.2026.
//

import Foundation
import SwiftUI

struct CategoryItemModel: Identifiable {

    let id: Int
    let name: String
    let photo: Image
    let expirationDate: Date
    let paoDate: Date
    let purchaseDate: Date
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
        return dateFormatter.string(from: paoDate)
    }

    var purchaseDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: purchaseDate)
    }

    var bestBeforeDate: Date {
        min(expirationDate, paoDate)
    }

    var bestBeforeDateString: String {
        let expireDate = min(expirationDate, paoDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.string(from: expireDate)
    }
}
