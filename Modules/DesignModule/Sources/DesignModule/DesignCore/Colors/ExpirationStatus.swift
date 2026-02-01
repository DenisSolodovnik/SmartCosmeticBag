//
//  ExpirationStatus.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

public enum ExpirationStatus {

    case expired
    case warning
    case good

    public var color: Color {
        switch self {
            case .expired: .init(.ExpirationStatuses.expired)
            case .warning: .init(.ExpirationStatuses.warning)
            case .good: .init(.ExpirationStatuses.good)
        }
    }

    public var textColor: Color {
        switch self {
            case .expired: .init(.ExpirationStatuses.expired)
            case .warning: .init(.ExpirationStatuses.warning)
            case .good: .init(.ExpirationStatuses.good)
        }
    }

    public var text: String {
        switch self {
            case .expired: "Истек"
            case .warning: "Истекает"
            case .good: "Норм"
        }
    }
}

public extension Color {

    static func expirationStatusColor(_ kind: ExpirationStatus) -> Color {
        kind.color
    }
}
