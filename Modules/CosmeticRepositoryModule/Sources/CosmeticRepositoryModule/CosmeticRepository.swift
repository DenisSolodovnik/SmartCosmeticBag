//
//  CosmeticRepository.swift
//  DataRepositoryModule
//
//  Created by Денис Солодовник on 04.02.2026.
//

import CoreData

protocol IdentifiableEntity where Self: NSManagedObject {

    associatedtype Identifier
    var id: Identifier? { get set }
}

public final actor CosmeticRepository: Sendable {

    let persistentController: CoreRepository
    private let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        persistentController = .init(inMemory: inMemory)
        container = persistentController.container
    }

    static func forceDeleteItems(forIds ids: [UUID], context: NSManagedObjectContext) throws {
        let fetchItemsDelete = NSFetchRequest<NSFetchRequestResult>(
            entityName: "ItemSummaryEntity"
        )
        fetchItemsDelete.predicate = NSPredicate(format: "id IN %@", ids)
        let deleteItemsRequest = NSBatchDeleteRequest(fetchRequest: fetchItemsDelete)
        deleteItemsRequest.resultType = .resultTypeObjectIDs

        let itemsResult = try context.execute(deleteItemsRequest) as? NSBatchDeleteResult
        if let deletedObjectIDs = itemsResult?.result as? [NSManagedObjectID] {
            let changes = [NSDeletedObjectsKey: deletedObjectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        }
    }

    static func loadItems<Entity: NSManagedObject & IdentifiableEntity>(
        byIds ids: [UUID],
        from context: NSManagedObjectContext
    ) throws -> [Entity] {
        let request = NSFetchRequest<Entity>(
            entityName: String(describing: Entity.self)
        )
        request.predicate = NSPredicate(format: "id IN %@", ids)

        return try context.fetch(request)
    }

    static func loadItem<Entity: NSManagedObject & IdentifiableEntity>(
        byId id: UUID,
        from context: NSManagedObjectContext
    ) throws -> Entity? {
        let request = NSFetchRequest<Entity>(
            entityName: String(describing: Entity.self)
        )
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        return try context.fetch(request).first
    }

    static func isDatabaseEmpty(in context: NSManagedObjectContext) throws -> Bool {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            return true
        }

        for entity in model.entities {
            guard let entityName = entity.name else { continue }

            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.fetchLimit = 1
            request.includesPropertyValues = false
            request.includesSubentities = false

            if try !context.fetch(request).isEmpty {
                return false
            }
        }

        return true
    }

    func isDatabaseEmpty() async throws -> Bool {
        try await persistentController.perform { context in
            try CosmeticRepository.isDatabaseEmpty(in: context)
        }
    }
}

extension ItemDetailEntity: IdentifiableEntity {}
extension ItemSummaryEntity: IdentifiableEntity {}
extension CategoryEntity: IdentifiableEntity {}
