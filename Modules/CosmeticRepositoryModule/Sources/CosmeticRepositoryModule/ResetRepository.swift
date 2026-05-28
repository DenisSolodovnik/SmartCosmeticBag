//
//  CosmeticRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 18.05.2026.
//

import CoreData

public protocol IResetRepository {

    func resetAllData() async throws
}

extension CosmeticRepository: IResetRepository {

    public func resetAllData() async throws {
        try await persistentController.perform { context in
            let model = context.persistentStoreCoordinator?.managedObjectModel
            let entityNames = model?.entities.compactMap { $0.name } ?? []

            for name in entityNames {
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
                deleteRequest.resultType = .resultTypeObjectIDs

                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                if let deletedObjectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: deletedObjectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            }
        }
    }
}
