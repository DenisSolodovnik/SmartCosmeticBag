//
//  FileStorage.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 27.02.2026.
//

import UIKit
import ImageIO
import LoggerModule

public protocol IStorage: Actor {

    func loadImageData(for key: PhotoKey) async throws -> Data
    func saveImageData(_ image: UIImage, for key: PhotoKey) async throws -> Data
    func deleteImageData(for key: PhotoKey) async throws
    func deleteImageData(for keys: [PhotoKey]) async throws
    func deleteAllImagesData() async throws
    func deleteAllImagesData(for categoryId: String) async throws
}

final actor FileStorage: IStorage {

    private enum FileOperation {

        case load
        case save
        case delete
    }

    private enum TaskResult {

        case data(Task<Data, Error>)
        case empty(Task<Void, Error>)
    }

    private let basePath: URL

    init() throws {
        let fileManager = FileManager.default
        do {
            basePath = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("PhotoStorage", isDirectory: true)
        } catch {
            EventLogger.instance.reportError(error: error)
            throw PhotoStorageError.cannotCreateDirectory(kind: .fileSystem, error: error)
        }

        do {
            try fileManager.createDirectory(at: basePath, withIntermediateDirectories: true)
        } catch {
            EventLogger.instance.reportError(error: error)
            throw PhotoStorageError.cannotCreateDirectory(
                kind: .fileSystem,
                path: basePath,
                error: error
            )
        }

        Self.excludeFromBackup(basePath)
    }

    func loadImageData(for key: PhotoKey) async throws -> Data {
        let fileURL = key.fileURL(basePath)

        let task = Task.detached(priority: .utility) { () throws -> Data in
            do {
                return try Data(contentsOf: fileURL, options: [.mappedIfSafe])
            } catch {
                EventLogger.instance.reportError(error: error)
                if FileManager.default.fileExists(atPath: fileURL.path) == false {
                    throw PhotoStorageError.fileNotFound(kind: .loadImage, path: fileURL, error: error)
                } else {
                    throw PhotoStorageError.cannotReadFile(kind: .loadImage, path: fileURL, error: error)
                }
            }
        }

        let fileData = try await task.value
        
        return fileData
    }

    func saveImageData(_ image: UIImage, for key: PhotoKey) async throws -> Data {
        guard  let data = image
            .jpegData(compressionQuality: 0.87) else {

            throw PhotoStorageError.cannotEncodeImage(kind: .saveImage)
        }

        try await writeImageData(from: data, for: key)

        return data
    }

    func deleteImageData(for key: PhotoKey) async throws {
        let fileManager = FileManager.default
        let fileURL = key.fileURL(basePath)

        let task = Task.detached(priority: .utility) {
            do {
                if !fileManager.fileExists(atPath: fileURL.path) { return }
                try fileManager.removeItem(at: fileURL)
            } catch {
                EventLogger.instance.reportError(error: error)
                throw PhotoStorageError.cannotDeleteFile(kind: .removeImage, path: fileURL, error: error)
            }
        }

        try await task.value
    }

    func deleteImageData(for keys: [PhotoKey]) async throws {
        try await withThrowingTaskGroup { group in
            for key in keys {
                group.addTask { try await self.deleteImageData(for: key) }
            }

            try await group.waitForAll()
        }
    }

    func deleteAllImagesData() async throws {
        let path = basePath

        if !FileManager.default.fileExists(atPath: path.path) { return }

        let task = Task.detached(priority: .utility) {
            do {
                try FileManager.default.removeItem(atPath: path.path)
            } catch {
                EventLogger.instance.reportError(error: error)
                throw PhotoStorageError
                    .cannotDeleteDirectory(kind: .removeAllImages, path: path, error: error)
            }
        }

        try await task.value
    }

    func deleteAllImagesData(for categoryId: String) async throws {
        let fileManager = FileManager.default
        let path = basePath.appendingPathComponent(categoryId)

        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: path.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {

            throw PhotoStorageError.cannotDeleteDirectory(kind: .removeAllImages, path: path)
        }

        let task = Task.detached(priority: .utility) {
            do {
                try fileManager.removeItem(atPath: path.path)
            } catch {
                EventLogger.instance.reportError(error: error)
                throw PhotoStorageError
                    .cannotDeleteDirectory(kind: .removeAllImages, path: path, error: error)
            }
        }

        try await task.value
    }
}

private extension FileStorage {

    func writeImageData(from data: Data, for key: PhotoKey) async throws {
        let fileURL = key.fileURL(basePath)

        let task = Task.detached(priority: .utility) {
            let fileManager = FileManager.default
            let directoryURL = fileURL.deletingLastPathComponent()

            do {
                try fileManager.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true
                )
            } catch {
                EventLogger.instance.reportError(error: error)
                throw PhotoStorageError
                    .cannotCreateDirectory(kind: .saveImage, path: fileURL, error: error)
            }

            do {
                try data.write(to: fileURL, options: .atomic)
            } catch {
                EventLogger.instance.reportError(error: error)
                throw PhotoStorageError
                    .cannotWriteFile(kind: .saveImage, path: fileURL, error: error)
            }
        }

        try await task.value
    }

    static func excludeFromBackup(_ path: URL) {
        var resourceValues = URLResourceValues()
        var _path = path
        resourceValues.isExcludedFromBackup = true

        do {
            try _path.setResourceValues(resourceValues)
        } catch {
            EventLogger.instance.reportError(error: error)
            print("PhotoStorage: Exclude from backup failed: ", error)
        }
    }
}

// MARK: - For use in XCTest

#if DEBUG

protocol ITestableStorage: IStorage {

    func filesCount(in directoryId: UUID) -> Int
}

extension FileStorage: ITestableStorage {

    public func filesCount(in directoryId: UUID) -> Int {
        let fileManager = FileManager.default
        let path = basePath.appendingPathComponent(directoryId.uuidString)

        var objCBool: ObjCBool = false
        if fileManager.fileExists(atPath: path.path, isDirectory: &objCBool),
           objCBool.boolValue {

            let contents = try? fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            return contents?.count ?? -1
        }

        return 0
    }
}

#endif
