//
//  PhotoCache.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 03.05.2026.
//

import Foundation

protocol IPhotoCache: Actor {

    func setObject(_ obj: Data, forKey key: PhotoKey, cost g: Int)
    func setObject(_ obj: Data, forKey key: PhotoKey)
    func setObjects(_ objects: [(obj: Data, key: PhotoKey)]) async throws
    func setObjects(_ objects: [(obj: Data, key: PhotoKey, cost: Int)]) async throws
    func object(forKey key: PhotoKey) -> Data?
    func removeObject(forKey key: PhotoKey)
    func removeObjects(forKeys keys: [PhotoKey])
    func removeAllObjects(forCategoryId id: UUID)
    func removeAllObjects()
}

extension IPhotoCache {

    func setObject(_ obj: Data, forKey key: PhotoKey) {
        setObject(obj, forKey: key, cost: 0)
    }
}

final actor PhotoCache: IPhotoCache {

    private let cache: NSCache<NSString, NSData> = .init()
    private var cachedKeys: [String: Set<PhotoKey>] = [:]

    func setObject(
        _ obj: Data,
        forKey key: PhotoKey,
        cost g: Int
    ) {
        let cacheKey = key.cacheKey as NSString
        let data = obj as NSData
        cachedKeys[key.categoryId, default: []].insert(key)

        guard !isCached(data, forKey: key.cacheKey as NSString) else { return }

        if g > 0 {
            cache.setObject(data, forKey: cacheKey, cost: g)
        } else {
            cache.setObject(data, forKey: cacheKey)
        }
    }

    func setObjects(_ objects: [(obj: Data, key: PhotoKey)]) async throws {
        try await withThrowingTaskGroup { group in
            for object in objects {
                group.addTask {
                    await self.setObject(object.obj, forKey: object.key)
                }
            }

            try await group.waitForAll()
        }
    }

    func setObjects(_ objects: [(obj: Data, key: PhotoKey, cost: Int)]) async throws {
        try await withThrowingTaskGroup { group in
            for object in objects {
                group.addTask {
                    await self.setObject(object.obj, forKey: object.key, cost: object.cost)
                }
            }

            try await group.waitForAll()
        }
    }

    func object(forKey key: PhotoKey) -> Data? {
        cache.object(forKey: key.cacheKey as NSString) as Data?
    }

    func removeObject(forKey key: PhotoKey) {
        cachedKeys[key.categoryId]?.remove(key)

        if cachedKeys[key.categoryId]?.isEmpty == true {
            cachedKeys[key.categoryId] = nil
        }

        guard isCached(forKey: key.cacheKey as NSString) else { return }

        cache.removeObject(forKey: key.cacheKey as NSString)
    }

    func removeObjects(forKeys keys: [PhotoKey]) {
        for key in keys {
            removeObject(forKey: key)
        }
    }

    func removeAllObjects(forCategoryId id: UUID) {
        let idString = id.uuidString
        guard let keys = cachedKeys[idString] else { return }

        cachedKeys[idString] = nil
        removeObjects(forKeys: Array(keys))
    }

    func removeAllObjects() {
        cachedKeys.removeAll()
        cache.removeAllObjects()
    }
}

private extension PhotoCache {

    func isCached(_ obj: NSData, forKey key: NSString) -> Bool {
        if let object = cache.object(forKey: key),
           object == obj { return true }

        return false
    }

    func isCached(forKey key: NSString) -> Bool {
        cache.object(forKey: key) != nil
    }
}

#if DEBUG

extension PhotoCache {

    func getKeys() -> [String: Set<PhotoKey>] {
        var result: [String: Set<PhotoKey>] = [:]
        for (key, value) in cachedKeys {
            result[key as String] = value
        }

        return result
    }

    func getCache(forKeys keys: [PhotoKey]) -> [String: Data] {
        var result: [String: Data] = [:]
        for key in keys {
            result[key.cacheKey] = cache.object(forKey: key.cacheKey as NSString) as Data?
        }

        return result
    }

    func getAllCache() -> [String: Data] {
        var result: [String: Data] = [:]
        for (key, _) in cachedKeys {
            result[key as String] = cache.object(forKey: key as NSString) as Data?
        }
        return result
    }
}

#endif
