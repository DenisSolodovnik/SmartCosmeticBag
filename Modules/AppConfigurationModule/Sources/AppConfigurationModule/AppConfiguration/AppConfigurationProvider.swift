//
//  AppConfigurationProvider.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

public actor AppConfigurationProvider {

    private let configurator: AppConfiguratorCore = .init()

    public init() {}

    public func loadAppConfiguration() async throws -> AppConfigurationModel {
        try await configurator.loadAppConfiguration()
    }
}
