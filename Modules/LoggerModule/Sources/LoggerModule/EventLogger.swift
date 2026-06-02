//
//  EventLogger.swift
//  LoggerModule
//
//  Created by Денис Солодовник on 31.05.2026.
//

import AppMetricaCore
import AppMetricaCrashes
import Foundation

public protocol IEventLogger: Sendable {

    static var instance: IEventLogger { get }

    func logEvent(builder: EventPathBuilder, onFailure: ((any Error) -> Void)?)
    func logEvent(builder: EventPathBuilder)
    func logError(builder: ErrorPathBuilder, onFailure: ((any Error) -> Void)?)
    func logError(builder: ErrorPathBuilder)
    func reportError(error: any Error, onFailure: ((any Error) -> Void)?)
    func reportError(error: any Error)
}

public extension IEventLogger {

    func logEvent(builder: EventPathBuilder) {
        logEvent(builder: builder, onFailure: nil)
    }

    func logError(builder: ErrorPathBuilder) {
        logError(builder: builder, onFailure: nil)
    }

    func reportError(error: any Error) {
        reportError(error: error, onFailure: nil)
    }
}

public final class EventLogger: IEventLogger, Sendable {

    public static let instance: IEventLogger = EventLogger()

    private init() {}

    public func logEvent(builder: EventPathBuilder, onFailure: ((any Error) -> Void)?) {
        AppMetrica.reportEvent(
            name: builder.buildPath(),
            parameters: builder.configuration,
            onFailure: onFailure
        )
    }

    public func logError(builder: ErrorPathBuilder, onFailure: ((any Error) -> Void)?) {
        AppMetrica.reportEvent(
            name: builder.buildPath(),
            parameters: builder.configuration,
            onFailure: onFailure
        )
    }

    public func reportError(error: any Error, onFailure: ((any Error) -> Void)?) {
        AppMetricaCrashes.crashes().report(nserror: error, onFailure: onFailure)
    }
}
