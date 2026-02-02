//
//  SmartCosmeticBagApp.swift
//  SmartCosmeticBag
//
//  Created by Денис Солодовник on 06.01.2026.
//

import SwiftUI
import CoreData
import CosmeticModule
import CosmeticDataPool

@main
struct SmartCosmeticBagApp: App {

    @StateObject private var coordinator: CosmeticCoordinator
    private let cosmeticDataPool: CosmeticDataPool

    init() {
        let pool = CosmeticDataPool()
        cosmeticDataPool = pool
        _coordinator = StateObject(wrappedValue: CosmeticCoordinator(cosmeticDataPool: pool))
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

//            LaunchView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
