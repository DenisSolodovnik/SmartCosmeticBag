//
//  DesignGlow.swift
//  DesignModule
//
//  Created by Денис Солодовник on 19.01.2026.
//

import SwiftUI

struct GlowData {

    let color: Color

    private let opacity: (light: Double, dark: Double)
    private let radius: (light: CGFloat, dark: CGFloat)

    init(
        color: Color,
        opacity: (light: Double,dark: Double),
        radius: (light: CGFloat, dark: CGFloat)
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
    }

    func opacity(for scheme: ColorScheme) -> Double {
        switch scheme {
            case .light: opacity.light
            case .dark: opacity.dark
            default: opacity.light
        }
    }

    func radius(for scheme: ColorScheme) -> CGFloat {
        switch scheme {
            case .light: radius.light
            case .dark: radius.dark
            default: radius.light
        }
    }
}

public enum GlowKind {

    case card
    case expirationStatus(ExpirationStatus)

    var data: GlowData {
        switch self {
            case .card:
                .init(
                    color: .init(.GlowColors.card),
                    opacity: (0.12, 0.15),
                    radius: (14, 28)
                )

            case let .expirationStatus(expirationKind):
                process(expirationKind)
        }
    }

    private func process(_ expirationKind: ExpirationStatus) -> GlowData {
        @Environment(\.colorScheme) var scheme: ColorScheme

        switch expirationKind {
            case .expired:
                return .init(
                    color: .init(.GlowColors.expired),
                    opacity: (0.30, 0.60),
                    radius: (0.14, 0.28)
                )

            case .warning:
                return .init(
                    color: .init(.GlowColors.warning),
                    opacity: (0.22, 0.45),
                    radius: (0.12, 0.22)
                )

            case .good:
                return .init(
                    color: .init(.GlowColors.good),
                    opacity: (0.12, 0.30),
                    radius: (0.80, 0.16)
                )
        }
    }
}
