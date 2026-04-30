import XCTest
@testable import PhotoStorage

final class PhotoStorageTests: XCTestCase {

    func testStorage() async throws {
        _ = try await createStorage()
    }

    func testInFlight() async throws {
        let storage = try await createStorage(with: MockedStorage.init)
    }

    func testSave() async throws {
        let categoryId = UUID()
        let key = PhotoKey(id: UUID(), categoryId: categoryId)
        let storage = try await createStorage()

        do {
            try await save(by: key, storage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Save: Unknown error")")
            return
        } catch {
            XCTFail("Save: PhotoStorage should not throw an error")
            return
        }

        try await delete(by: key, storage)
    }

    func testLoad() async throws {
        let key = PhotoKey(id: UUID(), categoryId: UUID())
        let storage = try await createStorage()

        try await save(by: key, storage)

        do {
            _ = try await load(by: key, storage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Load: Unknown error")")
        } catch {
            XCTFail("Load: PhotoStorage should not throw an error")
        }

        try await delete(by: key, storage)
    }

    func testDelete() async throws {
        let categoryId = UUID()
        let key = PhotoKey(id: UUID(), categoryId: categoryId)
        let storage = try await createStorage()

        try await save(by: key, storage)

        var count = await fileCount(for: categoryId, storage)
        if count == -1 {
            XCTFail("Can't count files")
        } else if count != 1 {
            XCTFail("Files count is incorrect == \(count)")
        }

        do {
            try await delete(by: key, storage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Delete: Unknown error")")
            return
        } catch {
            XCTFail("Delete: PhotoStorage should not throw an error")
            return
        }

        count = await fileCount(for: categoryId, storage)
        if count == -1 {
            XCTFail("Can't count files")
        } else if count > 0 {
            XCTFail("Files count is incorrect == \(count)")
        }
    }

    private func createStorage(
        with constructor: () throws -> IStorage = FileStorage.init
    ) async throws -> IPhotoStorage {

        let storage: IPhotoStorage
        do {
            storage = try PhotoStorage(with: constructor)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Storage: Unknown error")")
            throw error
        } catch {
            XCTFail("Storage: PhotoStorage should not throw an error")
            throw error
        }

        return storage
    }

    private func load(by key: PhotoKey, _ storage: IPhotoStorage) async throws -> UIImage {
        try await storage.getPhoto(for: key)
    }

    private func save(by key: PhotoKey, _ storage: IPhotoStorage) async throws {
        let image = UIImage(systemName: "arrow.2.circlepath.circle")!
        do {
            try await storage.setPhoto(image, for: key)
        } catch {
            throw error
        }
    }

    private func delete(by key: PhotoKey, _ storage: IPhotoStorage) async throws {
        try await storage.removePhoto(for: key)
    }

    private func fileCount(for directoryId: UUID, _ storage: IPhotoStorage) async -> Int {
        await storage.filesCount(in: directoryId)
    }
}

