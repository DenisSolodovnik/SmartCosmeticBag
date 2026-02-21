//
//  CategoryItemCard.swift
//  DesignModule
//
//  Created by Денис Солодовник on 20.01.2026.
//

import SwiftUI

public struct CategoryItemCard: View {

    let expirationStatus: ExpirationStatus
    let itemPhoto: Image?
    let expirationDate: String
    let paoDate: String

    public init(
        expirationStatus: ExpirationStatus,
        itemPhoto: Image?,
        expirationDate: String,
        paoDate: String
    ) {
        self.expirationStatus = expirationStatus
        self.itemPhoto = itemPhoto
        self.expirationDate = expirationDate
        self.paoDate = paoDate
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard))
            .foregroundStyle(Color.backgroundColor(.card))
            .overlay {
                HStack(spacing: .zero) {
                    itemPhotoCard()

                    VStack(spacing: .padding(.medium)) {
                        HStack(alignment: .top, spacing: .padding(.small)) {
                            itemNamePlate()
                            Spacer(minLength: .padding(.small))
                            expirationStatusPlate()
                        }

                        datesPlate()
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard))
                    .stroke(style: .init(lineWidth: 1, lineCap: .round))
                    .foregroundStyle(Color.strokeColor(.card))
            }
            .clipShape(RoundedRectangle(cornerRadius: .cornerSize(.categoryItemCard)))
            .glow(.card)
    }
}

private extension CategoryItemCard {

    func expirationStatusPlate() -> some View {
        HStack(spacing: .padding(.small)) {
            Text(expirationStatus.text)
                .foregroundStyle(expirationStatus.textColor)
                .accessibilityAddTraits(.isStaticText)
                .glow(.expirationStatus(expirationStatus))

            ExpirationStatusIcon(statusKind: expirationStatus)
        }
    }

    func itemPhotoCard() -> some View {
        guard let itemPhoto else {
            return Image(.noPhoto)
                .resizable()
        }

        return itemPhoto
            .resizable()
    }

    func itemNamePlate() -> some View {
        Text("gggg")
    }

    func datesPlate() -> some View {
        VStack(spacing: .padding(.small)) {
            expirationDatePlate()
            paoDatePlate()
        }
    }

    func expirationDatePlate() -> some View {
        HStack(spacing: .padding(.small)) {
            Text("EXP")
            Text(expirationDate)
        }
    }

    func paoDatePlate() -> some View {
        HStack(spacing: .padding(.small)) {
            Image(.DateKind.paoDate)
                .resizable()
                .frame(width: 48, height: 48)
            Text(paoDate)
        }
    }
}
