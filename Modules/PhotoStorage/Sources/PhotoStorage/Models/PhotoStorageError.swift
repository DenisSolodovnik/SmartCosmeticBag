//
//  PhotoStorageError.swift
//  PhotoStorage
//
//  Created by Денис Солодовник on 27.02.2026.
//

import Foundation

public enum PhotoStorageError: LocalizedError, Error {

    public enum MethodKind: String, Sendable {

        case fileSystem
        case loadImage
        case saveImage
        case removeImage
        case removeAllImages
        case prefetchImages
    }

    public enum ImageScaleError: String, Sendable {

        case invalidImageSize
        case failedToCreateJPEGData
    }

    case invalidPath(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotEncodeImage(kind: MethodKind, error: Error? = nil)
    case cannotScaleImage(kind: MethodKind, scaleError: ImageScaleError, error: Error? = nil)
    case invalidImageData(kind: MethodKind, error: Error? = nil)
    case fileNotFound(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotCreateDirectory(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotWriteFile(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotReadFile(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotDeleteFile(kind: MethodKind, path: URL? = nil, error: Error? = nil)
    case cannotDeleteDirectory(kind: MethodKind, path: URL? = nil, error: Error? = nil)

    public var description: String {
        switch self {
            case let .invalidPath(kind, path, _):
                "\(kind.rawValue): Не удалось найти путь для: \(path?.absoluteString, default: "")."
            case let .cannotEncodeImage(kind, _):
                "\(kind.rawValue): Не удалось закодировать изображение."
            case let .cannotScaleImage(kind, scaleError, _):
                "\(kind.rawValue): Не удалось уменьшить изображение. \(scaleError.rawValue)"
            case let .invalidImageData(kind, _):
                "\(kind.rawValue): Не удалось декодировать изображение."
            case let .fileNotFound(kind, url, _):
                "\(kind.rawValue): Файл не найден: \(url?.lastPathComponent, default: "")"
            case let .cannotCreateDirectory(kind, url, _):
                "\(kind.rawValue): Не удалось создать директорию: \(url?.path, default: "")"
            case let .cannotWriteFile(kind, url, _):
                "\(kind.rawValue): Не удалось записать файл: \(url?.path, default: "")"
            case let .cannotReadFile(kind, url, _):
                "\(kind.rawValue): Не удалось прочитать файл: \(url?.path, default: "")"
            case let .cannotDeleteFile(kind, url, _):
                "\(kind.rawValue): Не удалось удалить файл: \(url?.path, default: "")"
            case let .cannotDeleteDirectory(kind, url, _):
                "\(kind.rawValue): Не удалось удалить директорию: \(url?.path, default: "")"
        }
    }
}
