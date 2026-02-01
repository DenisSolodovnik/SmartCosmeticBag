//
//  ExpirationStatusIcon.swift
//  DesignModule
//
//  Created by Денис Солодовник on 20.01.2026.
//

import SwiftUI

public struct ExpirationStatusIcon: View {

    let statusKind: ExpirationStatus

    public var body: some View {
        Circle()
            .foregroundStyle(statusKind.color)
            .frame(width: 6, height: 6)
            .glow(.expirationStatus(statusKind))
    }
}
