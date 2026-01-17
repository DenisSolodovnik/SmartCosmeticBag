//
//  AppConfigurator.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import Foundation

final class AppConfigurator: Sendable {

    func loadAppConfiguration() async throws -> AppConfigurationModel {
        try await fetchConfiguration()
    }
}

private extension AppConfigurator {

    func fetchConfiguration() async throws -> AppConfigurationModel {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        return AppConfigurationModel()
    }
}
