//
//  AppSetting.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

public struct AppConfigurationModel: Sendable {
    public var categoryItems: [String] = [] // Replace [String] with a proper model if needed.

    public init(categoryItems: [String] = []) {
        self.categoryItems = categoryItems
    }
}
