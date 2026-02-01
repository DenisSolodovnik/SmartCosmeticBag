//
//  CategoryCard.swift
//  DesignModule
//
//  Created by Денис Солодовник on 20.01.2026.
//

import SwiftUI

public struct CategoryCard: View {

    let expirationStatus: ExpirationStatus

    public init(expirationStatus: ExpirationStatus) {
        self.expirationStatus = expirationStatus
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: .cornerSize(.categoryCard))
            .foregroundStyle(Color.backgroundColor(.card))
            .overlay {
                HStack(spacing: .padding(.extraSmall)) {
                    Image(.DateKind.paoDate)
                        .resizable()
                        .frame(width: 48, height: 48)
                    Text(expirationStatus.text)
                        .foregroundStyle(expirationStatus.textColor)
                        .accessibilityAddTraits(.isStaticText)
                        .glow(.expirationStatus(expirationStatus))
                    ExpirationStatusIcon(statusKind: expirationStatus)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.padding(.medium))
            }
            .overlay {
                RoundedRectangle(cornerRadius: .cornerSize(.categoryCard))
                    .stroke(style: .init(lineWidth: 1, lineCap: .round))
                    .foregroundStyle(Color.strokeColor(.card))
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerSize(.categoryCard)))
            .glow(.card)
    }
}
