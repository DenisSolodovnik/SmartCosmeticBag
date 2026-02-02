//
//  CosmeticCategoriesAssembly.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import SwiftUI
import AppConfigurationModule

public struct CosmeticCategoriesAssembly {

    public init() {}

    @MainActor public func assembly() -> some View {
        let configurationActor: AppConfigurationActor = .init()
        let viewModel = CosmeticCategoriesViewModel(configurationActor: configurationActor)

        return CosmeticCategoriesView(viewModel: viewModel)
    }
}
