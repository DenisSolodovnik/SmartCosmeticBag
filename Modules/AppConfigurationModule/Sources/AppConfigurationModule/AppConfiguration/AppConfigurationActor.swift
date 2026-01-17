//
//  AppConfigurationActor.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 12.01.2026.
//

public actor AppConfigurationActor {

    private let configurator: AppConfigurator = .init()

    public init() {}

    public func loadAppConfiguration() async throws -> AppConfigurationModel {
        try await configurator.loadAppConfiguration()
    }
}
