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

    func setScaledImageData(
        _ photo: UIImage,
        for key: PhotoKey,
        maxPixelSize: Int
    ) async throws

    func removePhoto(for key: PhotoKey) async throws
    func removePhotos(for keys: [PhotoKey]) async throws
    func removeAllPhotos() async throws
    func removeAllPhotos(for category: UUID) async throws
    func prefetch(for keys: [PhotoKey]) async throws
}

public final actor PhotoStorage: IPhotoStorage {

    private let storage: any IStorage
    private let cache: any IPhotoCache
    private var inFlightTasks: PhotoIdDictionary

    public init(with storage: (any IStorage)? = nil) throws {
        if let storage {
            self.storage = storage
        } else {
            self.storage = try FileStorage()
        }

        cache = PhotoCache()
        inFlightTasks = .init()
    }

    public func getPhoto(for key: PhotoKey) async throws -> UIImage {
        if let cachedData = await cache.object(forKey: key) {
            return try dataToPhoto(cachedData as Data)
        }

        let operation: FileOperation = .load

        if let existingTask = await inFlightTasks.value(forKey: key, and: operation),
           case let .data(task) = existingTask {

            let imageData = try await task.value
            return try dataToPhoto(imageData)
        }

        let fileStorage = storage
        let task = Task<Data, Error> {
            try await fileStorage.loadImageData(for: key)
        }

        await inFlightTasks.insert(.data(task), forKey: key, and: operation)

        let fileData = try await task.value
        let image = try dataToPhoto(fileData)

        await cache.setObject(fileData, forKey: key, cost: fileData.count)

        await inFlightTasks.removeValue(forKey: key, and: operation)

        return image
    }

    public func setPhoto(_ photo: UIImage, for key: PhotoKey) async throws {
        if let existingTask = await inFlightTasks.value(forKey: key, and: .save),
           case let .data(task) = existingTask {
            _ = try await task.value
            return
        }

        let fileStorage = storage
        let task: Task<Data, Error> = .init {
            try await fileStorage.saveImageData(photo, for: key)
        }

        await inFlightTasks.insert(.data(task), forKey: key, and: .save)

        let data = try await task.value
        await cache.setObject(data, forKey: key, cost: data.count)

        await inFlightTasks.removeValue(forKey: key, and: .save)
    }

    public func setScaledImageData(
        _ photo: UIImage,
        for key: PhotoKey,
        maxPixelSize: Int
    ) async throws {
        let scaledPhoto = try scale(image: photo, maxPixelSize: maxPixelSize)
        try await setPhoto(scaledPhoto, for: key)
    }

    public func removePhoto(for key: PhotoKey) async throws {
        if let existingTask = await inFlightTasks.value(forKey: key, and: .delete),
           case let .empty(task) = existingTask {

            return try await task.value
        }

        let fileStorage = storage
        let task = Task<Void, Error> {
            try await fileStorage.deleteImageData(for: key)
        }

        await inFlightTasks.insert(.empty(task), forKey: key, and: .delete)

        try await task.value
        await cache.removeObject(forKey: key)

        await inFlightTasks.removeValue(forKey: key, and: .delete)
    }

    public func removePhotos(for keys: [PhotoKey]) async throws {
        let fileStorage = storage
        try await withThrowingTaskGroup { group in
            for key in keys {
                group.addTask { try await fileStorage.deleteImageData(for: key) }
            }

            try await group.waitForAll()
        }

        await inFlightTasks.removeValues(forKeys: keys, and: .delete)
        await cache.removeObjects(forKeys: keys)
    }

    public func removeAllPhotos() async throws {
        try await storage.deleteAllImagesData()
        await cache.removeAllObjects()
    }

    public func removeAllPhotos(for category: UUID) async throws {
        try await storage.deleteAllImagesData(for: category.uuidString)
        await cache.removeAllObjects(forCategoryId: category)
    }

    public func prefetch(for keys: [PhotoKey]) async throws {}
}

private extension PhotoStorage {

    func dataToPhoto(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw PhotoStorageError.invalidImageData(kind: .loadImage)
        }

        return image
    }

    func scale(image: UIImage, maxPixelSize: Int) throws -> UIImage {
        let sourceSize = image.size

        guard sourceSize.width > 0, sourceSize.height > 0, maxPixelSize > 0 else {
            throw PhotoStorageError.cannotScaleImage(kind: .saveImage, scaleError: .invalidImageSize)
        }

        let maxSourceSide = max(sourceSize.width, sourceSize.height)
        let scaleFactor = Double(maxPixelSize) / maxSourceSide

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
