import XCTest
@testable import PhotoStorage

final class PhotoStorageTests: XCTestCase {

    func testStorage() async throws {
        _ = try await createStorage()
    }

    func testSave() async throws {
        let categoryId = UUID()
        let key = PhotoKey(id: UUID(), categoryId: categoryId)
        let storage = try await createStorage()

        do {
            try await PhotoStorageTests.save(by: key, storage.photoStorage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Save: Unknown error")")
            return
        } catch {
            XCTFail("Save: PhotoStorage should not throw an error")
            return
        }

        try await delete(by: key, storage.photoStorage)
    }

    func testSaveThreeShouldTestedManually() async throws {
        let categoryId = UUID()
        let imagesId = UUID()
        let images = [
            UIImage(systemName: "square.and.arrow.up")!,
            UIImage(systemName: "square.and.arrow.up.fill")!,
            UIImage(systemName: "square.and.arrow.up.circle")!
        ]
        let keys: [PhotoKey] = [
            PhotoKey(id: imagesId, categoryId: categoryId),
            PhotoKey(id: imagesId, categoryId: categoryId),
            PhotoKey(id: imagesId, categoryId: categoryId)
        ]

        let storage: (photoStorage: any IPhotoStorage, storage: any ITestableStorage)
        do {
            storage = try await createStorage()
        } catch {
            print(error)
            throw error
        }

        let photoStorage = storage.photoStorage

        try await withThrowingTaskGroup { group in
            for index in 0..<keys.count {
                group.addTask {
                    try await PhotoStorageTests.save(
                        by: keys[index],
                        photoStorage,
                        image: images[index]
                    )
                }
            }

            try await group.waitForAll()
        }

        /// Should be tested manually by compare images by eye
        let image = try await load(by: keys[2], storage.photoStorage)

        try await delete(by: keys[0], storage.photoStorage)
    }

    func testLoad() async throws {
        let key = PhotoKey(id: UUID(), categoryId: UUID())
        let storage = try await createStorage()

        try await PhotoStorageTests.save(by: key, storage.photoStorage)

        do {
            _ = try await load(by: key, storage.photoStorage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Load: Unknown error")")
        } catch {
            XCTFail("Load: PhotoStorage should not throw an error")
        }

        try await delete(by: key, storage.photoStorage)
    }

    func testDelete() async throws {
        let categoryId = UUID()
        let key = PhotoKey(id: UUID(), categoryId: categoryId)
        let storages = try await createStorage()

        try await PhotoStorageTests.save(by: key, storages.photoStorage)

        await checkFilesCount(in: storages.storage, for: categoryId)

        do {
            try await delete(by: key, storages.photoStorage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Delete: Unknown error")")
            return
        } catch {
            XCTFail("Delete: PhotoStorage should not throw an error")
            return
        }

        await checkFilesCount(in: storages.storage, for: categoryId, mandatory: 0)
    }

    func testDeleteAll() async throws {
        let categoryId1 = UUID()
        let categoryId2 = UUID()

        let key1 = PhotoKey(id: UUID(), categoryId: categoryId1)
        let key2 = PhotoKey(id: UUID(), categoryId: categoryId1)
        let key3 = PhotoKey(id: UUID(), categoryId: categoryId2)
        let storages = try await createStorage()

        try await PhotoStorageTests.save(by: key1, storages.photoStorage)
        try await PhotoStorageTests.save(by: key2, storages.photoStorage)
        try await PhotoStorageTests.save(by: key3, storages.photoStorage)

        await checkFilesCount(in: storages.storage, for: categoryId1, mandatory: 2)
        await checkFilesCount(in: storages.storage, for: categoryId2, mandatory: 1)

        try await storages.photoStorage.removeAllPhotos(for: categoryId1)
        await checkFilesCount(in: storages.storage, for: categoryId1, mandatory: 0)

        try await storages.photoStorage.removeAllPhotos()

        await checkFilesCount(in: storages.storage, for: categoryId1, mandatory: 0)
        await checkFilesCount(in: storages.storage, for: categoryId2, mandatory: 0)
    }

    private func createStorage() async throws -> (photoStorage: IPhotoStorage, storage: ITestableStorage) {

        let photoStorage: IPhotoStorage
        let storage: ITestableStorage

        do {
            storage = try FileStorage()
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "Storage: Unknown error")")
            throw error
        }

        do {
            photoStorage = try PhotoStorage(with: storage)
        } catch let error as PhotoStorageError {
            XCTFail("\(error.description, default: "PhotoStorage: Unknown error")")
            throw error
        }

        return (photoStorage, storage)
    }

    private func load(by key: PhotoKey, _ storage: IPhotoStorage) async throws -> UIImage {
        try await storage.getPhoto(for: key)
    }

    private static func save(
        by key: PhotoKey,
        _ storage: IPhotoStorage,
        image: UIImage = UIImage(systemName: "arrow.2.circlepath.circle")!
    ) async throws {
        try await storage.setPhoto(image, for: key)
    }

    private func delete(by key: PhotoKey, _ storage: IPhotoStorage) async throws {
        try await storage.removePhoto(for: key)
    }

    private func checkFilesCount(
        in storage: ITestableStorage,
        for directoryId: UUID,
        mandatory: Int = 1
    ) async {

        let count = await storage.filesCount(in: directoryId)
        if count == -1 {
            XCTFail("Can't count files")
        } else if count != mandatory {
            XCTFail("Files count is incorrect = \(count), mandatory = \(mandatory)")
        }
    }
}
