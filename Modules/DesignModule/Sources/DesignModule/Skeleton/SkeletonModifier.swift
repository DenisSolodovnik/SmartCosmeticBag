//
//  Skeleton.swift
//  DesignModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI

public extension View {

    func skeleton() -> some View {
        modifier(SkeletonModifier())
    }
}

struct SkeletonModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                SkeletonShimmer()
                    .mask(content)
            }
    }
}

struct SkeletonShimmer: View {

    @State private var phase: CGFloat = -1

    var body: some View {
        GeometryReader { geo in
            let viewWidth = geo.size.width
            let gradientWidth = viewWidth * 1.5

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0),
                    Color.gray.opacity(0.45),
                    Color.gray.opacity(0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geo.size.width * 1.5)
            .offset(x: -gradientWidth + phase * (viewWidth + gradientWidth))
            .onAppear {
                phase = -1
                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
        }
    }
}
