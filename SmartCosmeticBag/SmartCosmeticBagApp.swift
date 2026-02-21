//
//  SmartCosmeticBagApp.swift
//  SmartCosmeticBag
//
//  Created by Денис Солодовник on 06.01.2026.
//

import SwiftUI
import CoreData
import CosmeticModule
import CosmeticRepositoryModule

@main
struct SmartCosmeticBagApp: App {

    @StateObject private var coordinator: CosmeticCoordinator
    private let cosmeticRepository: CosmeticRepository

    init() {
        let repository = CosmeticRepository()
        cosmeticRepository = repository
        _coordinator = StateObject(wrappedValue: CosmeticCoordinator(cosmeticRepository: repository))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.categoryItems)
                    .navigationDestination(for: CosmeticScreens.self) { route in
                        coordinator.build(route)
                    }
            }
        }
    }
}

