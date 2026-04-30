//
//  PhotoStorage.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 27.02.2026.
//

import Foundation
import UIKit

public protocol IPhotoStorage: Actor {

    func getPhoto(for data: PhotoKey) async throws -> UIImage
    func setPhoto(_ photo: UIImage, for key: PhotoKey) async throws
    func setScaledImageData(_ photo: UIImage, for key: PhotoKey, maxPixelSize: Int) async throws
    func removePhoto(for key: PhotoKey) async throws
    func removePhotos(for keys: [PhotoKey]) async throws
    func removeAllPhotos() async throws
    func removeAllPhotos(for category: String) async throws
    func prefetch(for keys: [PhotoKey]) async throws
}

#if DEBUG
protocol ITestablePhotoStorage: Actor {

    func getInFlight(for keys: [PhotoKey]) -> [PhotoKey: [String: Int?]]
    func filesCount(in directoryId: UUID) async -> Int
}
#endif

public final actor PhotoStorage: IPhotoStorage {

    private enum FileOperation: String, CaseIterable {

        case load
        case save
        case delete
    }

    private enum TaskResult {

        case data(Task<Data, Error>)
        case empty(Task<Void, Error>)
    }

    private let storage: any IStorage

    private let cache = NSCache<NSString, NSData>()
    private var inFlightTasks: [PhotoKey: [FileOperation: TaskResult]] = [:]
    private var cachedKeys: [String: Set<PhotoKey>] = [:]

    public init() throws {
        self.storage = try FileStorage()
    }

    public init(with storage: () throws -> any IStorage) throws {
        self.storage = try storage()
    }

    public func getPhoto(for key: PhotoKey) async throws -> UIImage {
        if let cachedData = cache.object(forKey: key.cacheKey as NSString) {
            return try dataToPhoto(cachedData as Data)
        }

        if let taskKind = inFlightTasks[key],
           let existingTask = taskKind[.load],
           case let .data(task) = existingTask {

            let imageData = try await task.value
            return try dataToPhoto(imageData)
        }

        let fileStorage = storage
        let task = Task<Data, Error> {
            try await fileStorage.loadImageData(for: key)
        }

        inFlightTasks[key, default: [:]][.load] = .data(task)
        defer { inFlightTasks[key]?[.load] = nil }

        let fileData = try await task.value
        let image = try dataToPhoto(fileData)

        cachedKeys[key.categoryId, default: []].insert(key)
        cache.setObject(fileData as NSData, forKey: key.cacheKey as NSString, cost: fileData.count)

        return image
    }

    public func setPhoto(_ photo: UIImage, for key: PhotoKey) async throws {
        if let taskKind = inFlightTasks[key],
           let existingTask = taskKind[.save],
           case let .data(task) = existingTask {
            _ = try await task.value
            return
        }

        let fileStorage = storage
        let task: Task<Data, Error> = .init {
            try await fileStorage.saveImageData(photo, for: key)
        }

        inFlightTasks[key, default: [:]][.save] = .data(task)
        defer { inFlightTasks[key]?[.save] = nil }

        let data = try await task.value

        cachedKeys[key.categoryId, default: []].insert(key)
        cache.setObject(data as NSData, forKey: key.cacheKey as NSString, cost: data.count)
    }

    public func setScaledImageData(_ photo: UIImage, for key: PhotoKey, maxPixelSize: Int) async throws {
        let scaledPhoto = try scale(image: photo, maxPixelSize: maxPixelSize)
        try await setPhoto(scaledPhoto, for: key)
    }

    public func removePhoto(for key: PhotoKey) async throws {
        if let taskKind = inFlightTasks[key],
           let existingTask = taskKind[.delete],
           case let .empty(task) = existingTask {

            return try await task.value
        }

        let fileStorage = storage
        let task = Task<Void, Error> {
            try await fileStorage.deleteImageData(for: key)
        }

        inFlightTasks[key, default: [:]][.delete] = .empty(task)
        defer { inFlightTasks[key]?[.delete] = nil }

        try await task.value

        cache.removeObject(forKey: key.cacheKey as NSString)
        cachedKeys[key.categoryId]?.remove(key)
    }

    public func removePhotos(for keys: [PhotoKey]) async throws {
        let fileStorage = storage
        let allTasks: [(PhotoKey, Task<Void, Error>)] = keys.map { key in
            let task = Task<Void, Error> {
                try await fileStorage.deleteImageData(for: key)
            }

            return (key, task)
        }

        for (key, task) in allTasks {
            inFlightTasks[key, default: [:]][.delete] = .empty(task)
        }

        try await withThrowingTaskGroup { group in
            for (_, task) in allTasks {
                group.addTask { try await task.value }
            }

            try await group.waitForAll()
        }

        for (key, _) in allTasks {
            inFlightTasks[key]?[.delete] = nil
            cachedKeys[key.categoryId]?.remove(key)
            cache.removeObject(forKey: key.cacheKey as NSString)
        }
    }

    public func removeAllPhotos() async throws {
        try await storage.deleteAllImagesData()
        cachedKeys.removeAll()
        cache.removeAllObjects()
    }

    public func removeAllPhotos(for category: String) async throws {
        try await storage.deleteAllImagesData(for: category)
        guard let keys = cachedKeys[category] else { return }

        for key in keys {
            cache.removeObject(forKey: key.cacheKey as NSString)
            cachedKeys[key.categoryId]?.remove(key)
        }
    }

    public func prefetch(for keys: [PhotoKey]) async throws {

    }

    func hasInFlightTasks(for key: PhotoKey) -> Bool {
        if let taskKind = inFlightTasks[key],
           let task = taskKind[.load],
           case .data = task {
            return true
        }

        return false
    }

    func isCached(_ key: PhotoKey) -> Bool {
        cache.object(forKey: key.cacheKey as NSString) != nil
    }

    func cachedKeySet(for categoryId: String) -> Set<PhotoKey> {
        cachedKeys[categoryId] ?? []
    }

    public func getInFlight(for keys: [PhotoKey]) -> [PhotoKey: [String: Int?]] {
        var dictionary: [PhotoKey: [String: Int?]] = [:]

        for key in keys {
            let inFlight = inFlightTasks[key] ?? [:]
            for operation in FileOperation.allCases {
                dictionary[key, default: [:]][operation.rawValue] = inFlight[operation] == nil ? nil : 1
            }
        }

        return dictionary
    }

    public func filesCount(in directoryId: UUID) async -> Int {
        await storage.filesCount(in: directoryId)
    }

}

#if DEBUG
extension PhotoStorage: ITestablePhotoStorage {

}
#endif

private extension PhotoStorage {

    func dataToPhoto(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw PhotoStorageError.invalidImageData(kind: .loadImage)
        }

        return image
    }

    func scale(image: UIImage, maxPixelSize: Int) throws -> UIImage {
        let pixelSize = Double(maxPixelSize)
        let sourceSize = image.size

        guard sourceSize.width > 0, sourceSize.height > 0, pixelSize > 0 else {
            throw PhotoStorageError.cannotScaleImage(kind: .saveImage, scaleError: .invalidImageSize)
        }

        let maxSourceSide = max(sourceSize.width, sourceSize.height)
        let scaleFactor = pixelSize / maxSourceSide

        let targetSize = CGSize(
            width: sourceSize.width * scaleFactor,
            height: sourceSize.height * scaleFactor
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resizedImage = renderer.image { context in
            let cgContext = context.cgContext
            cgContext.interpolationQuality = .high

            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resizedImage
    }
}
