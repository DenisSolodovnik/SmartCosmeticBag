//
//  GlowModifier.swift
//  DesignModule
//
//  Created by Денис Солодовник on 20.01.2026.
//

import SwiftUI

public struct GlowModifier: ViewModifier {

    let glowKind: GlowKind
    let intensity: Double

    @Environment(\.colorScheme) private var scheme: ColorScheme

    public func body(content: Content) -> some View {
        let glowData: GlowData = glowKind.data

        return content
            .shadow(
                color: glowData.color.opacity(glowData.opacity(for: scheme)),
                radius: glowData.radius(for: scheme),
                x: 0,
                y: 0
            )
    }
}

public extension View {

    func glow(_ kind: GlowKind, intensity: Double = 0.5) -> some View {
        modifier(GlowModifier(glowKind: kind, intensity: intensity))
    }
}
