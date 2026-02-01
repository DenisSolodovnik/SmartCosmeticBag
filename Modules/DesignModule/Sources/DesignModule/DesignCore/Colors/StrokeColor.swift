//
//  StrokeColor.swift
//  DesignModule
//
//  Created by Денис Солодовник on 30.01.2026.
//


//
//  StrokeColor.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

public enum StrokeColor {

    case card

    var value: Color {
        switch self {
            case .card: .init(.StrokeColors.card)
        }
    }
}

public extension Color {

    static func strokeColor(_ kind: StrokeColor) -> Color {
        kind.value
    }
}
