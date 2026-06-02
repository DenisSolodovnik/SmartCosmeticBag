//
//  SmartCosmeticBagApp.swift
//  SmartCosmeticBag
//
//  Created by Денис Солодовник on 06.01.2026.
//

import AppMetricaCore
import CoreData
import CosmeticModule
import CosmeticRepositoryModule
import LoggerModule
import PhotoStorage
import SwiftUI

@main
struct SmartCosmeticBagApp: App {

    @StateObject private var coordinator: CosmeticCoordinator
    private let cosmeticRepository: CosmeticRepository
    private let photoStorage: IPhotoStorage

    init() {
        if let configuration = AppMetricaConfiguration(
            apiKey: "76f0ab53-e9fe-4976-8d8c-4ffdcaf6eac2"
        ) {
            AppMetrica.activate(with: configuration)
        }
        let repository = CosmeticRepository()
        let storage: IPhotoStorage
        do {
            storage = try PhotoStorage()
        } catch let error as PhotoStorageError {
            let path = ErrorPathBuilder()
                .error(name: "Can't create PhotoStorage", error: error)
                .module(name: "SmartCosmeticBug")
                .criticalScale(1)
            EventLogger.instance.logError(builder: path, onFailure: nil)
            fatalError(error.description)
        } catch {
            EventLogger.instance.reportError(error: error, onFailure: nil)
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
                coordinator.build(.itemsSummary)
                    .navigationDestination(for: CosmeticScreens.self) { route in
                        coordinator.build(route)
                    }
            }
        }
    }
}

