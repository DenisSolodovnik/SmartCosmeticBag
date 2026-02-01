//
//  BackgroundColor.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

public enum BackgroundColor {

    case view
    case card

    var value: Color {
        switch self {
            case .view: .init(.BackgroundColors.view)
            case .card: .init(.BackgroundColors.card)
        }
    }
}

public extension Color {

    static func backgroundColor(_ kind: BackgroundColor) -> Color {
        kind.value
    }
}
