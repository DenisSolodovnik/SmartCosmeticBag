//
//  Padding.swift
//  DesignModule
//
//  Created by Денис Солодовник on 21.01.2026.
//

import Foundation

public enum Padding {

    case zero
    case extraSmall
    case small
    case medium
    case large
    case mediumLarge
    case extraLarge

    public var value: CGFloat {
        switch self {
            case .zero: 0
            case .extraSmall: 2
            case .small: 4
            case .medium: 8
            case .mediumLarge: 16
            case .large: 24
            case .extraLarge: 32
        }
    }
}

public extension CGFloat {

    static func padding(_ padding: Padding) -> CGFloat {
        padding.value
    }
}
