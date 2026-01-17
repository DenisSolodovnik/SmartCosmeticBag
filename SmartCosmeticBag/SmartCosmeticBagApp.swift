//
//  SmartCosmeticBagApp.swift
//  SmartCosmeticBag
//
//  Created by Денис Солодовник on 06.01.2026.
//

import SwiftUI
import CoreData
import CosmeticModule

@main
struct SmartCosmeticBagApp: App {

    @StateObject private var coordinator = CosmeticCoordinator.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(.categoriesList)
                    .navigationDestination(for: CosmeticScreens.self) { route in
                        coordinator.build(route)
                    }
            }
        }

//            LaunchView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
