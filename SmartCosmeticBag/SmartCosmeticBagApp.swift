//
//  SmartCosmeticBagApp.swift
//  SmartCosmeticBag
//
//  Created by Денис Солодовник on 06.01.2026.
//

import SwiftUI
import CoreData

@main
struct SmartCosmeticBagApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
