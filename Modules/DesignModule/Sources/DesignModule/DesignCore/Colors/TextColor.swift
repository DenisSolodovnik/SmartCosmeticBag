//
//  TextColor.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

public enum TextColor {

    case card
    case background

    public var value: Color {
        switch self {
            case .card: .init(.TextColors.card)
            case .background: .init(.TextColors.background)
        }
    }
}

public extension Color {

    static func textColor(_ kind: TextColor) -> Color {
        kind.value
    }
}
