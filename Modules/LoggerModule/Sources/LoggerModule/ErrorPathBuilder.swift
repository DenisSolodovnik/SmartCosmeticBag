//
//  ErrorPathBuilder.swift
//  LoggerModule
//
//  Created by Денис Солодовник on 01.06.2026.
//


public class ErrorPathBuilder {

    private var eventsChain: [String] = []
    public private(set) var configuration: [AnyHashable: Any] = [:]

    public init() {}

    public func error(
        name: String,
        error: any Error,
        file: String = #file,
        line: Int = #line
    ) -> Self {
        eventsChain.append("error")
        configuration[name] = error
        configuration["file"] = file
        configuration["line"] = line

        return self
    }

    public func module(name: String) -> Self {
        eventsChain.append("module_\(name)")
        return self
    }

    /// `1` is `most` critical, `9` is `lesser` critical
    public func criticalScale(_ number: Int) -> Self {
        eventsChain.append("\(number)")
        configuration["critical_scale"] = number
        return self
    }

    func buildPath() -> String {
        eventsChain.joined(separator: "/")
    }
}
