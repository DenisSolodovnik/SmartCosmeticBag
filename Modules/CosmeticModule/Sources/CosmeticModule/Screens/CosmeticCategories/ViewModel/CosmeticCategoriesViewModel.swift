//
//  CosmeticCategoriesViewModel.swift
//  CosmeticModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

import Foundation
import AppConfigurationModule

@MainActor
final class CosmeticCategoriesViewModel: ObservableObject {

    @Published var isLoading: Bool = true

    private let configurationActor: AppConfigurationActor
    private var configuration: AppConfigurationModel?

    init(configurationActor: AppConfigurationActor) {
        self.configurationActor = configurationActor
    }

    func loadConfiguration() async {
        do {
            configuration = try await configurationActor.loadAppConfiguration()
            isLoading = false
        } catch {

        }
    }
}
