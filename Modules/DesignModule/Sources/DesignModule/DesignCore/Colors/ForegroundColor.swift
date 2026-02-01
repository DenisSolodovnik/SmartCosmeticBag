//
//  ForegroundColor.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

public enum ForegroundColor {

    case accent

    var value: Color {
        switch self {
            case .accent: .init(.accent)
        }
    }
}

public extension Color {

    static func foregroundColor(_ kind: ForegroundColor) -> Color {
        kind.value
    }
}
