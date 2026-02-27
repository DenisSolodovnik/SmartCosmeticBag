//
//  AppSetting.swift
//  AppConfigurationModule
//
//  Created by Денис Солодовник on 11.01.2026.
//

public struct AppConfigurationModel: Sendable {

    public var categoryItems: [String] = []

    public init(categoryItems: [String] = []) {
        self.categoryItems = categoryItems
    }
}
