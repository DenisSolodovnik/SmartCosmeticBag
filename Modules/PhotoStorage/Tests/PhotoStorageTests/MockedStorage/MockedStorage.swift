//
//  MockedStorage.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 13.04.2026.
//

import Foundation
import UIKit
@testable import PhotoStorage

final actor MockedStorage: IStorage {

    func loadImageData(for key: PhotoKey) async throws -> Data {
        Data()
    }
    
    func saveImageData(_ image: UIImage, for key: PhotoKey) async throws -> Data {
        Data()
    }
    
    func deleteImageData(for key: PhotoKey) async throws {
    }
    
    func deleteImageData(for keys: [PhotoKey]) async throws {
    }
    
    func deleteAllImagesData() async throws {
    }
    
    func deleteAllImagesData(for categoryId: String) async throws {
    }
    
    func prefetchImageData(for keys: [PhotoKey]) async throws {
    }
    
    func filesCount(in directoryId: UUID) -> Int {
        0
    }
}
