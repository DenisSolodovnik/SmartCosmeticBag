//
//  CornerSize.swift
//  DesignModule
//
//  Created by Денис Солодовник on 21.01.2026.
//

import Foundation

public enum CornerSize {

    case categoryCard
    case smallCard
    case button
    case bottomSheet
    case icon

    public var value: CGFloat {
        switch self {
            case .categoryCard: 16
            case .smallCard: 12
            case .button: 14
            case .bottomSheet: 24
            case .icon: 12
        }
    }
}

public extension CGFloat {

    static func cornerSize(_ kind: CornerSize) -> CGFloat {
        kind.value
    }
}
