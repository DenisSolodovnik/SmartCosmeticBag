//
//  AppConfiguratorCore.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

import Foundation

final class AppConfiguratorCore: Sendable {

    func loadAppConfiguration() async throws -> AppConfigurationModel {
        try await fetchConfiguration()
    }
}

private extension AppConfiguratorCore {

    func fetchConfiguration() async throws -> AppConfigurationModel {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return AppConfigurationModel()
    }
}
