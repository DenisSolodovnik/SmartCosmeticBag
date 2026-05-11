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
import PhotoStorage

@main
struct SmartCosmeticBagApp: App {

    @StateObject private var coordinator: CosmeticCoordinator
    private let cosmeticRepository: CosmeticRepository
    private let photoStorage: IPhotoStorage

    init() {
        let repository = CosmeticRepository()
        let storage: IPhotoStorage
        do {
            storage = try PhotoStorage()
        } catch let error as PhotoStorageError {
            fatalError(error.description)
        } catch {
            fatalError("\(error.localizedDescription, default: "Unknown error")")
        }

        cosmeticRepository = repository
        photoStorage = storage

        _coordinator = StateObject(
            wrappedValue: CosmeticCoordinator(
                cosmeticRepository: repository,
                photoStorage: storage
            )
        )
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

